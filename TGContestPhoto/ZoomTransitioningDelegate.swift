//
//  ZoomTransitioningDelegate.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomTransitioningDelegate: NSObject {

	weak var interactiveTransition: UIPercentDrivenInteractiveTransition?
	var unclenchLocation: CGPoint = .zero

	// MARK: - Private properties

	private let previewRect: CGRect
	private let pinchLocation: CGPoint

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
		ZoomOutDismissAnimationController(
			originYFromView: previewRect.origin.y,
			unclenchLocation: unclenchLocation
		)
	}

	func interactionControllerForPresentation(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? {
		interactiveTransition
	}

	func interactionControllerForDismissal(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? {
		interactiveTransition
	}
}
