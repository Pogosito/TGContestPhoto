//
//  ZoomOutDismissAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 30.07.2023.
//

import UIKit

final class ZoomOutDismissAnimationController: NSObject {}

extension ZoomOutDismissAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { 1.5 }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		guard let fromView = transitionContext.view(forKey: .from),
			  let toView = transitionContext.viewController(forKey: .to)?.view else {
			print("STRANGE")
			return
		}

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = .identity
			toView.transform = .identity
			toView.frame.origin = .zero
			print("ANIMATION START")
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			print("ANIMATION COMPLETE:, \(transitionWasCompleted)")
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
