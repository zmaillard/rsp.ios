import XCTest
import UIKit
@testable import rpbrowser

final class ImageLoaderViewModelTests: XCTestCase {
    func testFetchSetsLoadedStateWhenServiceSucceeds() async {
        let image = makeImage(color: .blue)
        let service = MockImageService(result: .success(image))
        let viewModel = ImageLoaderViewModel(service: service)

        await viewModel.fetch(for: "https://example.com/test.jpg")

        XCTAssertEqual(viewModel.state, .loaded(image))
        XCTAssertEqual(service.callCount, 1)
    }

    func testFetchSetsErrorStateWhenServiceThrowsApiError() async {
        let service = MockImageService(result: .failure(APIError.invalidURL))
        let viewModel = ImageLoaderViewModel(service: service)

        await viewModel.fetch(for: "bad-url")

        XCTAssertEqual(viewModel.state, .error("The URL is Invalid"))
    }

    func testFetchSetsUnknownErrorForNonApiError() async {
        let service = MockImageService(result: .failure(MockError.generic))
        let viewModel = ImageLoaderViewModel(service: service)

        await viewModel.fetch(for: "https://example.com/test.jpg")

        XCTAssertEqual(viewModel.state, .error("unknown error"))
    }

    func testFetchDoesNotStartSecondRequestWhileLoading() async {
        let image = makeImage(color: .orange)
        let service = MockImageService(result: .success(image))
        let viewModel = ImageLoaderViewModel(service: service)
        viewModel.state = .loading

        await viewModel.fetch(for: "https://example.com/test.jpg")

        XCTAssertEqual(service.callCount, 0)
        XCTAssertEqual(viewModel.state, .loading)
    }

    private func makeImage(color: UIColor, size: CGSize = CGSize(width: 8, height: 8)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

private final class MockImageService: ImageService {
    private let result: Result<UIImage, Error>
    private(set) var callCount = 0

    init(result: Result<UIImage, Error>) {
        self.result = result
    }

    func fetch(_ url: String) async throws -> UIImage {
        callCount += 1
        switch result {
        case .success(let image):
            return image
        case .failure(let error):
            throw error
        }
    }

    func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        callCount += 1
        switch result {
        case .success(let image):
            return image
        case .failure(let error):
            throw error
        }
    }
}

private enum MockError: Error {
    case generic
}
