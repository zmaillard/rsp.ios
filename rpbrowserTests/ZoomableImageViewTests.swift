import XCTest
import SwiftUI
import UIKit
@testable import rpbrowser

@MainActor
final class ZoomableImageViewTests: XCTestCase {
    func testViewForZoomingReturnsFirstSubview() {
        let coordinator = ZoomableImageView.Coordinator()
        let scrollView = UIScrollView()
        let imageView = UIImageView(image: makeImage())
        scrollView.addSubview(imageView)

        let zoomView = coordinator.viewForZooming(in: scrollView)

        XCTAssertTrue(zoomView === imageView)
    }

    func testViewForZoomingReturnsNilWhenNoSubviews() {
        let coordinator = ZoomableImageView.Coordinator()
        let scrollView = UIScrollView()

        XCTAssertNil(coordinator.viewForZooming(in: scrollView))
    }

    func testScrollViewDidZoomRecentersImageViewWhenContentIsSmallerThanBounds() {
        let coordinator = ZoomableImageView.Coordinator()
        let scrollView = UIScrollView()
        let imageView = UIImageView(image: makeImage())
        scrollView.addSubview(imageView)

        scrollView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        scrollView.contentSize = CGSize(width: 120, height: 160)

        coordinator.scrollViewDidZoom(scrollView)

        XCTAssertEqual(imageView.center.x, 100, accuracy: 0.001)
        XCTAssertEqual(imageView.center.y, 150, accuracy: 0.001)
    }

    func testScrollViewDidZoomKeepsCenteredWhenContentExceedsBounds() {
        let coordinator = ZoomableImageView.Coordinator()
        let scrollView = UIScrollView()
        let imageView = UIImageView(image: makeImage())
        scrollView.addSubview(imageView)

        scrollView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        scrollView.contentSize = CGSize(width: 300, height: 200)

        coordinator.scrollViewDidZoom(scrollView)

        XCTAssertEqual(imageView.center.x, 150, accuracy: 0.001)
        XCTAssertEqual(imageView.center.y, 100, accuracy: 0.001)
    }

    private func makeImage(color: UIColor = .red, size: CGSize = CGSize(width: 8, height: 8)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
