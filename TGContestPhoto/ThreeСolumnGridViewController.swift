//
//  ThreeСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ThreeСolumnGridViewController: UIViewController {

	lazy var zoomTransitioningDelegate = ZoomTransitioningDelegate(
		previewRect: previewRect,
		pinchLocation: pinchLocation
	)

	private let previewRect: CGRect
	private let pinchLocation: CGPoint

	private var interactionController: UIPercentDrivenInteractiveTransition?

	private lazy var pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(
		target: self,
		action: #selector(didPinch(_:))
	)

	private lazy var zoomOutTransitionDelegate = transitioningDelegate as? ZoomTransitioningDelegate

	init(
		previewRect: CGRect,
		pinchLocation: CGPoint
	) {
		self.previewRect = previewRect
		self.pinchLocation = pinchLocation
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .custom
		transitioningDelegate = zoomTransitioningDelegate
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .purple
		view.alpha = 0.4
		view.addGestureRecognizer(pinchGesture)
	}

	@objc func tap() {
		dismiss(animated: true)
	}

	@objc func didPinch(_ sender: UIPinchGestureRecognizer) {

		if sender.scale > 1.0 { return }

		switch sender.state {
		case .began:
			interactionController = UIPercentDrivenInteractiveTransition()
			zoomOutTransitionDelegate?.interactiveTransition = interactionController
			dismiss(animated: true)
		case .changed: zoomOutTransitionDelegate?.interactiveTransition?.update((1 - sender.scale) / (3.0 / 5.0))
		case .ended, .possible, .failed, .cancelled:
			(1 - sender.scale) / (3.0 / 5.0) > 0.25
			? zoomOutTransitionDelegate?.interactiveTransition?.finish()
			: zoomOutTransitionDelegate?.interactiveTransition?.cancel()
		@unknown default: return
		}
	}
}
