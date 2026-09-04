//
//  ImageLoaderViewModel.swift
//  rpbrowser
//
//  Created by Zach Maillard on 9/2/26.
//

import Foundation
import UIKit

@Observable
class ImageLoaderViewModel {
    var state: LoadingState<UIImage> = .idle
    
    private let service: ImageService
    
    init(service: ImageService = DefaultImageService()) {
        self.service = service
    }
    
    
    func fetch(for imageUrl: String) async {
        print(imageUrl)
        guard !state.isLoading || state.error != nil else { return }
        self.state = .loading
        do {
            let image =  try await service.fetch(imageUrl)
            self.state = .loaded(image)
        } catch let error as APIError{
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
    /*
     // MARK: - Preview
     static var example: CountryDetailsViewModel {
     let svc = MockSignSearchService()
     let vm = CountryDetailsViewModel(service: svc)
     vm.state = .loaded(Country.example)
     return vm
     }
     */
}



