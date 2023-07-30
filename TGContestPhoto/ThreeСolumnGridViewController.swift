//
//  ThreeСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ThreeСolumnGridViewController: UIViewController {

	var button: UIButton = UIButton(frame: .init(origin: .init(x: 30, y: 30), size: .init(width: 50, height: 50)))

	private lazy var pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(
		target: self,
		action: #selector(didPinch(_:))
	)

	private lazy var zoomOutTransitionDelegate = transitioningDelegate as? ZoomTransitioningDelegate

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .purple
		view.alpha = 0.4
		button.backgroundColor = .red
		view.addSubview(button)
		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
		view.addGestureRecognizer(pinchGesture)
	}

	@objc func tap() {
		dismiss(animated: true)
	}

	@objc func didPinch(_ sender: UIPinchGestureRecognizer) {

		print((1 - sender.scale) / (3.0 / 5.0))

		if sender.scale > 1.0 { print("1111"); return }
		switch sender.state {
		case .began:
			print("DISMISS")
			dismiss(animated: true)
		case .changed: zoomOutTransitionDelegate?.helper2.update((1 - sender.scale) / (3.0 / 5.0))
		case .ended, .possible, .failed, .cancelled:
			(1 - sender.scale) / (3.0 / 5.0) > 0.25
			? zoomOutTransitionDelegate?.helper2.finish()
			: zoomOutTransitionDelegate?.helper2.cancel()
		@unknown default: return
		}
	}
}
