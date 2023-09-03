//
//  ZoomOutDismissAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomOutDismissAnimationController: NSObject {

	private let unclenchLocation: CGPoint
	private let originYFromView: CGFloat

	init(
		originYFromView: CGFloat,
		unclenchLocation: CGPoint
	) {
		self.originYFromView = originYFromView
		self.unclenchLocation = unclenchLocation
	}
}

extension ZoomOutDismissAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { 1.5 }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		guard let fromView = transitionContext.view(forKey: .from),
			  let toView = transitionContext.viewController(forKey: .to)?.view else {
			return
		}

		toView.frame.origin.x = 0

		fromView.setAnchorPoint(
			(fromView.frame.origin.absPoint() + unclenchLocation) / CGPoint(x: fromView.frame.width, y: fromView.frame.height)
		)

		let toViewAnchorPoint = CGPoint(
			x: 0,
			y: ((abs(toView.frame.origin.y) + unclenchLocation.y) / toView.frame.height)
		)

		toView.setAnchorPoint(toViewAnchorPoint)

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = .identity
			toView.transform = .identity
			toView.frame.origin.y = 0
			fromView.frame.origin.y = self.originYFromView
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
