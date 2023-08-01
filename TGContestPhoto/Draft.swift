//
//  Draft.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 25.06.2023.
//

import UIKit

// MARK: - ViewController2

final class ViewController2: UIViewController {

	lazy var slider = UISlider(frame: .init(origin: .init(x: 0, y: view.frame.height - 50),
									   size: .init(width: view.frame.width, height: 40)))

	let someView = UIButton(frame: CGRect(origin: .init(x: 150, y: 500), size: .init(width: 50, height: 50)))
	let someView2 = UIView(frame: CGRect(origin: .init(x: 100, y: 100), size: .init(width: 50, height: 50)))

	var lastSliderValue: Float = 0

	private let imageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "back"))
		imageView.frame = CGRect(origin: .zero, size: .init(width: 1000, height: 3000))
		return imageView
	}()

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.translatesAutoresizingMaskIntoConstraints = false
//		scrollView.isScrollEnabled = false
//		scrollView.bouncesZoom = false
		scrollView.maximumZoomScale = 100
		scrollView.minimumZoomScale = 1.0
		scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.backgroundColor = .green
		return scrollView
	}()

	private lazy var helperView: UIView = {
		let helperView = UIView()
		helperView.backgroundColor = .brown
		helperView.alpha = 0.7
//		helperView.frame.size = CGSize(width: itemWidth, height: itemWidth)
		return helperView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
//		view.backgroundColor = .clear
//		view.window?.addSubview(someView)
//
//		addScrollView()
//		scrollView.addSubview(imageView)
//
//		slider.minimumValue = 1.0
//		slider.maximumValue = 5.0

		someView.setAnchorPoint(.init(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1)))
		someView.backgroundColor = .red
		someView.addTarget(self, action: #selector(someFunction), for: .touchUpInside)
		
		view.addSubview(slider)
//		print("myCalc X:", someView.frame.origin.x - (someView.frame.width - someView.frame.width * someView.anchorPoint.x))
//		print("myCalc Y:", someView.frame.origin.y - (someView.frame.height - someView.frame.height * someView.anchorPoint.y))
		print("myCalc X:", (someView.frame.origin.x + (someView.anchorPoint.x * someView.frame.width)) - (someView.anchorPoint.x * someView.frame.height * 5))
		print("myCalc Y:", (someView.frame.origin.y + (someView.anchorPoint.y * someView.frame.height)) - (someView.anchorPoint.y * someView.frame.height * 5))
		print("-------------------------------------------------------")
//		print(someView.frame)
//		slider.addTarget(self, action: #selector(someFunction), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.delegate?.window!?.addSubview(someView)
	}

	@objc func someFunction() {
		let cgFloatScaleValue = CGFloat(slider.value)
//		someView.setAnchorPoint(CGPoint(x: , y: <#T##CGFloat#>))
		someView.transform = CGAffineTransformMakeScale(5, 5)
		print(someView.frame)
	}

	func addScrollView() {
		view.addSubview(scrollView)

		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension ViewController2: UIScrollViewDelegate {

	func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let scale = scrollView.zoomScale

		someView.transform = CGAffineTransform(
			scaleX: scale,
			y: scale
		)

	}
}

//private lazy var scrollView: UIScrollView = {
//	let scrollView = UIScrollView()
//	scrollView.delegate = self
//	scrollView.translatesAutoresizingMaskIntoConstraints = false
//	scrollView.isScrollEnabled = false
//	scrollView.bouncesZoom = false
//	scrollView.maximumZoomScale = finalZoomScale
//	scrollView.minimumZoomScale = 1.0
//	scrollView.contentInsetAdjustmentBehavior = .never
//	scrollView.backgroundColor = .green
//	return scrollView
//}()

//// MARK: - UIScrollViewDelegate
//
//extension FiveСolumnGridViewController: UIScrollViewDelegate {
//
//	func viewForZooming(in scrollView: UIScrollView) -> UIView? { collectionView }
//
//	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//		guard let pinchLocation = scrollView.pinchGestureRecognizer?.location(in: self.view) else { return }
//
//		let offset = calculateOffset(
//			zoomScale: finalZoomScale,
//			contentSize: viewFrame.size * finalZoomScale,
//			by: change(pinchLocation: pinchLocation)
//		)
//
//		let previewOrigin = CGPoint(
//			x: offset.x / finalZoomScale + 0.6,
//			y: offset.y / finalZoomScale + currentScrollViewYContentOffset
//		)
//
//		firstCellAfterZoom = cell(by: previewOrigin)
//
//		guard let firstCellOriginAfterZoom = firstCellAfterZoom?.frame.origin,
//			  let lastCellOriginAfterZoom = cell(
//				by: CGPoint(
//					x: previewOrigin.x + (itemWidth * 3),
//					y: previewOrigin.y + itemWidth * 7
//				)
//			  )?.frame.origin else {
//			return
//		}
//
//		let lowerRightCornerOfLastCell = lastCellOriginAfterZoom + itemWidth
//		let sizeOfPreview = lowerRightCornerOfLastCell - firstCellOriginAfterZoom
//
//		finalZoomRect = CGRect(
//			origin: firstCellOriginAfterZoom,
//			size: CGSize(width: sizeOfPreview.x, height: sizeOfPreview.y)
//		)
//
//		print(finalZoomRect)
//
//		zoomPresentAnimation.initialFrame = finalZoomRect
//
//		present(threeColumnGridViewController, animated: true)
//	}
//
//	func scrollViewDidZoom(_ scrollView: UIScrollView) {
//		guard let pinchGestureRecognizer = scrollView.pinchGestureRecognizer else { return }
//		let pinchLocation = pinchGestureRecognizer.location(in: view)
//		let zoomScale = scrollView.zoomScale
//
//		let newPinchLocation = change(pinchLocation: pinchLocation)
//
//		scrollView.contentOffset = calculateOffset(
//			zoomScale: zoomScale,
//			contentSize: scrollView.contentSize,
//			by: newPinchLocation
//		)
//
//		zoomPresentAnimation.scaleToView(
//			by: zoomScale,
//			origin: view.convert(
//				firstCellAfterZoom?.frame.origin ?? .zero,
//				from: collectionView
//			)
//		)

//		zoomPresentAnimation.update((zoomScale - 1) / (finalZoomScale - 1))
//	}

//	func scrollViewDidEndZooming(_ scrollView: UIScrollView,
//								 with view: UIView?,
//								 atScale scale: CGFloat) {
//		zoomPresentAnimation.finish()
//		if scale - 1 < 0.5 {
//			zoomPresentAnimation.cancel()
//		} else {
//			zoomPresentAnimation.finish()
//		}
//	}
//}
