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
	private var containerView: UIView?

	override func update(_ percentComplete: CGFloat) {}

	func scalePreview(by scaleFactor: CGFloat, contentOffset: CGPoint) {
//		print(containerView?.frame.origin)
//		print(contentOffset)
//		containerView?.frame.origin = CGPoint(x: -contentOffset.x, y: -contentOffset.y)

//		containerView?.frame.origin ?? .zero - contentOffset
//		print(containerView?.frame.origin)
//		print("----------------------------")
//		let containerFrame = containerView?.frame ?? .zero
//
//		let t = CGAffineTransformTranslate(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor),
//										   containerFrame.width / 2,
//										   containerFrame.height / 2)
//

//		containerView?.setAnchorPoint(.zero)
//		print(containerView?.anchorPoint)
		containerView?.transform = CGAffineTransform(
			scaleX: scaleFactor,
			y: scaleFactor
		)

//		print(containerView?.frame)
	}
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ZoomPresentAnimationController: UIViewControllerAnimatedTransitioning {

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval { myDuration }

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let toView = transitionContext.view(forKey: .to),
			  let toViewController = transitionContext.viewController(forKey: .to) else { return }

		toView.frame = initialFrame

		containerView = transitionContext.containerView
		containerView?.addSubview(toView)
		center = containerView!.center

		transitionContext.completeTransition(true)

//		UIView.animate(
//			withDuration: myDuration,
//			animations: {
//				toView.frame = transitionContext.finalFrame(for: toViewController)
//			},
//			completion: { _ in
//				print("COMPETE")
//				self.containerView = nil
//				transitionContext.completeTransition(true)
//			}
//		)
	}
}

