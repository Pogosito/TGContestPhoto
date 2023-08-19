//
//  ZoomOutDismissAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomOutDismissAnimationController: NSObject {

	private let unclenchLocation: CGPoint

	init(unclenchLocation: CGPoint) {
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


		toView.transform = .identity

		fromView.setAnchorPoint(unclenchLocation / CGPoint(x: fromView.frame.width, y: UIScreen.main.bounds.height))
		toView.setAnchorPoint(unclenchLocation / CGPoint(x: toView.frame.width, y: UIScreen.main.bounds.height))

		toView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)

		print("2 FROM ANCHOR POINT:", fromView.anchorPoint)
		print("2 TO ANCHOR POINT:", toView.anchorPoint)
		print("-----------------")

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = fromView.transform.scaledBy(x: 3.0 / 5.0, y: 3.0 / 5.0)
			toView.transform = toView.transform.scaledBy(x: 3.0 / 5.0, y: 3.0 / 5.0)
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
