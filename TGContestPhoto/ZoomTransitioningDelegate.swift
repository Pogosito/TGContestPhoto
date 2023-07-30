//
//  ZoomTransitioningDelegate.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomTransitioningDelegate: NSObject {

	private let previewRect: CGRect
	private let pinchLocation: CGPoint
	let helper = UIPercentDrivenInteractiveTransition()
	let helper2 = UIPercentDrivenInteractiveTransition()

	init(
		previewRect: CGRect,
		pinchLocation: CGPoint
	) {
		self.previewRect = previewRect
		self.pinchLocation = pinchLocation
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension ZoomTransitioningDelegate: UIViewControllerTransitioningDelegate {

	func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		ZoomPresentAnimationController(
			previewRect: previewRect,
			pinchLocation: pinchLocation
		)
	}

	func animationController(
		forDismissed dismissed: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		print("DISMISS DELEGATE")
		return ZoomOutDismissAnimationController()
	}

	func interactionControllerForPresentation(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? { helper }

	func interactionControllerForDismissal(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? { helper2 }
}
