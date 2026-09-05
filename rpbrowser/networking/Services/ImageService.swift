//
//  ImageService.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/3/26.
//

import Foundation
import SwiftUI
import CryptoKit

protocol ImageService {
    func fetch(_ url: String) async throws -> UIImage
    func fetch(_ urlRequest: URLRequest) async throws -> UIImage
}

actor DefaultImageService: ImageService {
    public func fetch(_ url: String) async throws -> UIImage {
        guard let imageUrl = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        let urlRequest = URLRequest(url: imageUrl)
        return try await fetch(urlRequest)
    }
    
    public func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        do {
            let (imageData, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }

            if let mimeType = httpResponse.mimeType,
               !mimeType.starts(with: "image/") {
                throw APIError.invalidResponse
            }

            guard let image = UIImage(data: imageData) else {
                throw APIError.invalidResponse
            }

            return image
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    
}

