//
//  ThreeСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

// Какая картинка первая после зума ?

/*
 зум в первую секцию:
 0/2/1
*/

final class ThreeСolumnGridViewController: UIViewController {
 
	lazy var zoomTransitioningDelegate = ZoomTransitioningDelegate(
		previewRect: previewRect,
		pinchLocation: pinchLocation
	)

	// MARK: - Private properties

	private let cellId: String = "collectionCellId"
	private let previewRect: CGRect
	private let pinchLocation: CGPoint
	private let topInset: CGFloat
	private let bottomInset: CGFloat

	private var previousScreenOriginX: CGFloat = 0
	private var presentingVelocity: CGFloat = 0
	private var interactionController: UIPercentDrivenInteractiveTransition?

	private lazy var itemWidth: CGFloat = (previewRect.width - 2) / 3.0
	//	(previewRect.width - 2) / 3.0

	// MARK: UI

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

		let frame: CGRect = CGRect(
			origin: .zero,
			size: CGSize(
				width: previewRect.width,
				height: previewRect.height
			)
		)

		let collectionView = UICollectionView(
			frame: frame,
			collectionViewLayout: layout
		)

		// HACK, i don't know why initial value of contentOffset cant different from zero
		// if you disable isScrollEnabled contentOffset be zero 100%
		// i enable isScrollEnabled in viewDidAppear
		collectionView.isScrollEnabled = false
		collectionView.alwaysBounceVertical = true
		collectionView.dataSource = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)

		let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(
			target: self,
			action: #selector(didPinch(_:))
		)

		collectionView.addGestureRecognizer(pinchGesture)
		return collectionView
	}()

	// MARK: - Init

	init(
		previewRect: CGRect,
		pinchLocation: CGPoint,
		topInset: CGFloat,
		bottomInset: CGFloat,
		presentingVelocity: CGFloat
	) {
		self.previewRect = previewRect
		self.pinchLocation = pinchLocation
		self.topInset = topInset
		self.bottomInset = bottomInset
		self.presentingVelocity = presentingVelocity
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .custom
		transitioningDelegate = zoomTransitioningDelegate
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		var alphaAnimationDuration: CGFloat = 0.5
		if presentingVelocity > 0.5 { alphaAnimationDuration = 0 }

		UIView.animate(withDuration: alphaAnimationDuration) { self.view.alpha = 1 }

		DispatchQueue.main.async {
			self.collectionView.contentInset.top = self.topInset + 28.5
			self.collectionView.contentInset.bottom = self.bottomInset
			self.collectionView.isScrollEnabled = true
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}

// MARK: - UICollectionViewDataSource

extension ThreeСolumnGridViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int { 123 }

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		cell.backgroundColor = .blue
		let label = UILabel()
		label.text = "\(indexPath.row)(\(indexPath.row / 3)|\(indexPath.row % 3))"
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .white
		label.textAlignment = .center
		cell.backgroundView = label

		return cell
	}
}

// MARK: - Private

// MARK: Actions

private extension ThreeСolumnGridViewController {

	@objc func didPinch(_ sender: UIPinchGestureRecognizer) {

		let unclenchLocation: CGPoint = change(pinchLocation: sender.location(in: view))

		switch sender.state {
		case .began:
			if sender.scale > 1.0 { return }
			interactionController = UIPercentDrivenInteractiveTransition()
			zoomTransitioningDelegate.interactiveTransition = interactionController
			zoomTransitioningDelegate.unclenchLocation = unclenchLocation
			zoomTransitioningDelegate.xPositionOfFiveColumnController = previousScreenOriginX
			dismiss(animated: true)
		case .changed: zoomTransitioningDelegate.interactiveTransition?.update((1 - sender.scale) / (3.0 / 5.0))
		case .ended, .possible, .failed, .cancelled:
			(1 - sender.scale) / (3.0 / 5.0) > 0.25
			? zoomTransitioningDelegate.interactiveTransition?.finish()
			: zoomTransitioningDelegate.interactiveTransition?.cancel()
		@unknown default: return
		}
	}
}

// MARK: Helper methods

private extension ThreeСolumnGridViewController {

	func change(pinchLocation: CGPoint) -> CGPoint {
		var newLocation: CGPoint = CGPoint(x: 0, y: pinchLocation.y)

		switch section(for: pinchLocation) {
		case .first:
			previousScreenOriginX = 0
			newLocation.x = 0
		case .second:
			previousScreenOriginX = itemWidth * (5.0 / 3.0) + 1
			newLocation.x = view.frame.midX
		case .third:
			previousScreenOriginX = 2 * (itemWidth * (5.0 / 3.0) + 1)
			newLocation.x = view.frame.width
		case .none: return .zero
		}

		return newLocation
	}

	func section(for pinchLocation: CGPoint) -> Section? {

		if pinchLocation.x > itemWidth && pinchLocation.x < itemWidth * 2 {
			return .second
		} else if pinchLocation.x < itemWidth {
			return .first
		} else if pinchLocation.x > itemWidth * 2 {
			return .third
		}

		return .none
	}
}

// MARK: Setup UI

private extension ThreeСolumnGridViewController {

	func setupUI() {
		view.alpha = 0
		view.addSubview(collectionView)
	}
}
