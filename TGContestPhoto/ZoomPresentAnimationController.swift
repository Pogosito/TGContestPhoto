//
//  ZoomPresentAnimationController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ZoomPresentAnimationController: UIPercentDrivenInteractiveTransition {

	var initialFrame: CGRect = .zero
	var center: CGPoint = .zero
	var isHidden: Bool = true

	// MARK: - Private properties

	private let myDuration: TimeInterval = 1.0

	private var toView: UIView?

	func scaleToView(by scaleFactor: CGFloat, origin: CGPoint) {
		toView?.frame.origin = origin

		toView?.transform = CGAffineTransform(
			scaleX: scaleFactor,
			y: scaleFactor
		)
	}

	override func update(_ percentComplete: CGFloat) {
		if percentComplete > 0.3 {
			
		}
	}
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomPresentAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { myDuration }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let toView = transitionContext.view(forKey: .to) else { return }

		toView.frame = initialFrame
		transitionContext.containerView.addSubview(toView)
		self.toView = toView
	}
}
