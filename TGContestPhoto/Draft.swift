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

	let someView = UIView(frame: CGRect(origin: .init(x: 100, y: 100), size: .init(width: 50, height: 50)))
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
		scrollView.maximumZoomScale = 5.0 / 3.0
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
		view.backgroundColor = .clear
		view.window?.addSubview(someView)

		addScrollView()
		scrollView.addSubview(imageView)

		slider.minimumValue = 1.0
		slider.maximumValue = 2.0
		someView.backgroundColor = .red

		view.addSubview(slider)
		slider.addTarget(self, action: #selector(someFunction), for: .valueChanged)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.delegate?.window!?.addSubview(someView)
	}

	@objc func someFunction() {
		let cgFloatScaleValue = CGFloat(slider.value)
		someView.transform = CGAffineTransform(scaleX: cgFloatScaleValue, y: cgFloatScaleValue)

//		CGAffineTransformMakeScale(cgFloatScaleValue, cgFloatScaleValue)
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
