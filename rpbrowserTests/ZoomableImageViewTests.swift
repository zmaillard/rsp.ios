import XCTest
import SwiftUI
import UIKit
@testable import rpbrowser

final class ZoomableImageViewTests: XCTestCase {
    func testMakeUIViewConfiguresScrollViewZoomProperties() {
        let sut = ZoomableImageView(image: makeImage())

        let scrollView = sut.makeUIView(context: makeContext(for: sut))

        XCTAssertEqual(scrollView.minimumZoomScale, 1.0)
        XCTAssertEqual(scrollView.maximumZoomScale, 5.0)
        XCTAssertTrue(scrollView.bouncesZoom)
        XCTAssertNotNil(scrollView.delegate)
    }

    func testMakeUIViewEmbedsUIImageViewWithProvidedImage() {
        let image = makeImage(color: .green)
        let sut = ZoomableImageView(image: image)

        let scrollView = sut.makeUIView(context: makeContext(for: sut))
        let imageView = scrollView.subviews.first as? UIImageView

        XCTAssertNotNil(imageView)
        XCTAssertEqual(imageView?.image?.pngData(), image.pngData())
        XCTAssertEqual(imageView?.contentMode, .scaleAspectFit)
        XCTAssertEqual(imageView?.translatesAutoresizingMaskIntoConstraints, false)
    }

    func testViewForZoomingReturnsFirstSubview() {
        let sut = ZoomableImageView(image: makeImage())
        let scrollView = sut.makeUIView(context: makeContext(for: sut))
        let coordinator = sut.makeCoordinator()

        let zoomView = coordinator.viewForZooming(in: scrollView)

        XCTAssertTrue(zoomView === scrollView.subviews.first)
    }

    func testScrollViewDidZoomRecentersImageViewWhenContentIsSmallerThanBounds() {
        let sut = ZoomableImageView(image: makeImage())
        let scrollView = sut.makeUIView(context: makeContext(for: sut))
        let coordinator = sut.makeCoordinator()

        let imageView = tryUnwrap(scrollView.subviews.first as? UIImageView)
        scrollView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        scrollView.contentSize = CGSize(width: 120, height: 160)

        coordinator.scrollViewDidZoom(scrollView)

        XCTAssertEqual(imageView.center.x, 100, accuracy: 0.001)
        XCTAssertEqual(imageView.center.y, 150, accuracy: 0.001)
    }

    func testScrollViewDidZoomKeepsCenteredWhenContentExceedsBounds() {
        let sut = ZoomableImageView(image: makeImage())
        let scrollView = sut.makeUIView(context: makeContext(for: sut))
        let coordinator = sut.makeCoordinator()

        let imageView = tryUnwrap(scrollView.subviews.first as? UIImageView)
        scrollView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        scrollView.contentSize = CGSize(width: 300, height: 200)

        coordinator.scrollViewDidZoom(scrollView)

        XCTAssertEqual(imageView.center.x, 150, accuracy: 0.001)
        XCTAssertEqual(imageView.center.y, 100, accuracy: 0.001)
    }

    func testUpdateUIViewDoesNotChangeZoomScale() {
        let sut = ZoomableImageView(image: makeImage())
        let context = makeContext(for: sut)
        let scrollView = sut.makeUIView(context: context)
        scrollView.zoomScale = 2.0

        sut.updateUIView(scrollView, context: context)

        XCTAssertEqual(scrollView.zoomScale, 2.0)
    }

    private func makeContext(for view: ZoomableImageView) -> ZoomableImageView.Context {
        ZoomableImageView.Context(coordinator: view.makeCoordinator())
    }

    private func makeImage(color: UIColor = .red, size: CGSize = CGSize(width: 8, height: 8)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
