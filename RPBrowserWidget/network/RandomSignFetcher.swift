//
//  RandomSignFetcher.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/15/26.
//
import Foundation
import UIKit

struct RandomSignFetcher {
    enum RandomSignFetcherError: Error {
        case invalidImageData
        case invalidUrl
    }
    
    private static var cachePath: URL {
        URL.cachesDirectory.appending(path: "random-sign.jpg")
    }
    
    static var cachedSign: UIImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    static var cachedDataAvailable: Bool {
        cachedSign != nil
    }

    static func fetchRandomSign() async throws -> (UIImage, RoadSignDetails) {
        let service = DefaultSignSearchService()
        let rootItems = try await service.fetchRoot()
        
        let randomNum = Int.random(in: 0..<rootItems.imageCount)
        
        let url = "https://roadsign.pictures/signindex/\(randomNum)/index.json"
        let randomSign = try await service.fetchSignDetail(from: url)
        guard let imageUrl = URL(string: randomSign.image.medium) else {
            throw RandomSignFetcherError.invalidUrl
        }
        let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
        
        guard let image = UIImage(data: imageData) else {
            throw RandomSignFetcherError.invalidImageData
        }
        
        Task {
            try? await cache(imageData)
        }
        
        return (image, randomSign)
        
    }
    
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}
