//
//  ZoomOutDismissAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomOutDismissAnimationController: NSObject {

	private let unclenchLocation: CGPoint

	init(unclenchLocation: CGPoint) { self.unclenchLocation = unclenchLocation }
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

		toView.transform = .identity

		fromView.setAnchorPoint(unclenchLocation / CGPoint(x: fromView.frame.width, y: fromView.frame.height))

		let toViewAnchorPoint = CGPoint(
			x: (unclenchLocation.x + fromView.frame.origin.x - toView.frame.origin.x) / toView.frame.width,
			y: (unclenchLocation.y + fromView.frame.origin.y - toView.frame.origin.y) / toView.frame.height
		)

		toView.setAnchorPoint(toViewAnchorPoint)

		toView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = .identity
			toView.transform = .identity
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
