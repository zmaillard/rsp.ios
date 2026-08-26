//
//  MapView.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/25/26.
//

import Foundation
import UIKit
import MapLibre
import SwiftUI

struct MapView: UIViewRepresentable {
    
    let OPENFREEMAP_LIBERTY_STYLE = URL(string: "https://tiles.openfreemap.org/styles/liberty")
    let onSignTapped: ((String) -> Void)
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        mapView.styleURL = OPENFREEMAP_LIBERTY_STYLE
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        
        // Set the map's center coordinate and zoom level.
        let boise = CLLocationCoordinate2D(latitude: 46.0, longitude: -116.0)
        mapView.setCenter(boise, animated: false)
        mapView.zoomLevel = 8
        
        let singleTap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleMapTap(sender:))
        )
        
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        
        mapView.delegate = context.coordinator
        
        
        return mapView
    }
    
    func updateUIView(_: MLNMapView, context _: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MLNMapViewDelegate {
        var parent: MapView
        var selectedSignCoordinate: CLLocationCoordinate2D?
        var currentAnnotation: SignAnnotation?
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        
        
        func mapView(_ mapView: MLNMapView, tapOnCalloutFor annotation: MLNAnnotation) {
            guard let signAnnotation = annotation as? SignAnnotation else { return }
            
            /*
             if let callback = onSignTapped {
             callback(signAnnotation.imageid)
             } else {
             print("🚧 Navigation stub: would navigate to sign \(signAnnotation.imageid)")
             }
             */
        }
        
        func mapView(_ mapView: MLNMapView, didDeselect annotation: MLNAnnotation) {
            // When callout is dismissed, clear the selection
            if annotation is SignAnnotation {
                clearSelection(mapView)
            }
        }

        
        
        func mapView(_ mapView: MLNMapView, annotationCanShowCallout annotation: MLNAnnotation) -> Bool {
            return annotation is SignAnnotation
        }

        func mapView(_: MLNMapView, didFinishLoading style: MLNStyle) {
            let source = MLNVectorTileSource(identifier: "demotiles", configurationURL: URL(string: "https://map.roadsign.pictures/services/sign")!)
            style.addSource(source)
            
            
            let layer = MLNCircleStyleLayer(identifier: "signs-style", source: source)
            
            
            layer.sourceLayerIdentifier = "signs"
            layer.circleRadius = NSExpression(forConstantValue: 8)
            
            
            style.addLayer(layer)
            
            // Add selection highlighting layer
            let selectedSource = MLNShapeSource(identifier: "selected-sign-source", shape: nil, options: nil)
            style.addSource(selectedSource)
            
            let selectedLayer = MLNCircleStyleLayer(identifier: "selected-sign-style", source: selectedSource)
            selectedLayer.circleRadius = NSExpression(forConstantValue: 8)
            selectedLayer.circleColor = NSExpression(forConstantValue: UIColor.systemBlue)
            selectedLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
            selectedLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
            style.addLayer(selectedLayer)
        }
        
        func clearSelection(_ mapView:MLNMapView) {
            self.selectedSignCoordinate = nil
            
            // Clear highlight
            if let source = mapView.style?.source(withIdentifier: "selected-sign-source") as? MLNShapeSource {
                source.shape = nil
            }
            
            // Remove annotation
            if let annotation = self.currentAnnotation {
                mapView.removeAnnotation(annotation)
                self.currentAnnotation = nil
            }
        }
        func updateSelectedSign(_ mapView:MLNMapView, coordinate: CLLocationCoordinate2D) {
            self.selectedSignCoordinate = coordinate
            let point = MLNPointAnnotation()
            point.coordinate = coordinate
            
            if let source = mapView.style?.source(withIdentifier: "selected-sign-source") as? MLNShapeSource {
                source.shape = point
            }
        }
        
        func showCallout(_ mapView:MLNMapView, for imageid: String, title: String, coordinate: CLLocationCoordinate2D) {
            // Remove existing annotation
            if let existing = currentAnnotation {
                mapView.removeAnnotation(existing)
            }
            
            // Create annotation with offset coordinate (slightly above the actual point)
            let offsetCoordinate = offsetCoordinateForCallout(coordinate)
            let annotation = SignAnnotation(coordinate: offsetCoordinate, imageid: imageid, title: title)
            mapView.addAnnotation(annotation)
            self.currentAnnotation = annotation
            
            // Select it to show callout
            mapView.selectAnnotation(annotation, animated: true)
        }
        
        func offsetCoordinateForCallout(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
            // Offset the coordinate slightly north so callout appears above the sign
            // This is roughly 0.0001 degrees latitude (~11 meters)
            return CLLocationCoordinate2D(latitude: coordinate.latitude + 0.0001, longitude: coordinate.longitude)
        }
        
        
        
        @objc func handleMapTap(sender: UITapGestureRecognizer) {
            guard let mapView = sender.view as? MLNMapView else { return }
            
            //Buffer point
            let buffer = 10.0
            let tapPoint:CGPoint = sender.location(in: mapView)
            let bufferedRect = CGRect(origin: tapPoint, size: CGSize(width: buffer, height: buffer))
            
            
            //let tapRect = mapView.convert(bufferedRect, toCoordinateBoundsFrom: nil)
            let features = mapView.visibleFeatures(in: bufferedRect, styleLayerIdentifiers: Set(["signs-style"]))
            print(features)
            if let feature = features.first,
               let imageid = feature.attribute(forKey: "imageid") as? String,
               let title = feature.attribute(forKey: "title") as? String,
               let pointFeature = feature as? MLNPointFeature {
                let coordinate = pointFeature.coordinate
                
                // Update selection highlight
                updateSelectedSign(mapView, coordinate: coordinate)
                
                // Show callout with offset
                showCallout(mapView, for: imageid, title: title, coordinate: coordinate)
                
            } else {
                // Tapped empty space - clear selection
                clearSelection(mapView)
            }
        }
    }
    
}
