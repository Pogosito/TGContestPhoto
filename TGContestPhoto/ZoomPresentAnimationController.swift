//
//  ZoomPresentAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ZoomPresentAnimationController: NSObject {

	// MARK: - Private properties

	private let duration: TimeInterval = 1.5
	private let initialFrame: CGRect
	private let anchorPoint: CGPoint

	// MARK: - Init

	init(initialFrame: CGRect, anchorPoint: CGPoint) {
		self.initialFrame = initialFrame
		self.anchorPoint = anchorPoint
	}
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomPresentAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { duration }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

		guard let fromView = transitionContext.viewController(forKey: .from)?.view,
			  let toView = transitionContext.view(forKey: .to) else { return }

		toView.frame = initialFrame

		toView.setAnchorPoint(anchorPoint)
		fromView.setAnchorPoint(anchorPoint)

		transitionContext.containerView.addSubview(toView)

		UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
			fromView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)
			toView.transform = CGAffineTransform(scaleX: 5.0 / 3.0, y: 5.0 / 3.0)
			toView.frame.origin = .zero
		} completion: { isSuccess in
			let transitionWasCompleted = !transitionContext.transitionWasCancelled && isSuccess
			transitionContext.completeTransition(transitionWasCompleted)
		}
	}
}
