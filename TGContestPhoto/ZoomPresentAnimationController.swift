//
//  ZoomPresentAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ZoomPresentAnimationController: NSObject {

	// MARK: - Private properties

	private let previewRect: CGRect
	private let pinchLocation: CGPoint

	private var toView: UIView?

	// MARK: - Init

	init(previewRect: CGRect, pinchLocation: CGPoint) {
		self.previewRect = previewRect
		self.pinchLocation = pinchLocation
	}
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomPresentAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { 1.5 }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		guard let fromView = transitionContext.viewController(forKey: .from)?.view,
			  let toView = transitionContext.view(forKey: .to) else { return }

		self.toView = toView
		toView.frame = previewRect

		fromView.setAnchorPoint(pinchLocation / CGPoint(x: fromView.frame.size.width, y: fromView.frame.size.height))
		toView.setAnchorPoint(fromView.convert(pinchLocation, to: toView) / CGPoint(x: previewRect.width, y: previewRect.height))

		transitionContext.containerView.addSubview(toView)

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)
			toView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
