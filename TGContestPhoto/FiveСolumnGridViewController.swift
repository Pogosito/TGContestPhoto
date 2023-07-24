//
//  FiveСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 24.06.2023.
//

import UIKit

final class FiveСolumnGridViewController: UIViewController {

	// MARK: - Private properties

	private let cellId: String = "collectionCellId"
	private let zoomPresentAnimation = ZoomPresentAnimationController()
	private let zoomInteractiveTransitioning = UIPercentDrivenInteractiveTransition()

	private var currentScrollViewYContentOffset: CGFloat = 0
	private var lastZoomScale: CGFloat = .zero
	private var firstCellAfterZoom: UICollectionViewCell?

	private lazy var viewFrame: CGRect = view.frame
	private lazy var itemWidth: CGFloat = (viewFrame.width - (0.5 * 6)) / 5
	private lazy var finalZoomScale: Double = 5.0 / 3.0

	// MARK: UI

	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.delegate = self
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.isScrollEnabled = false
		scrollView.bouncesZoom = false
		scrollView.maximumZoomScale = finalZoomScale
		scrollView.minimumZoomScale = 1.0
		scrollView.contentInsetAdjustmentBehavior = .never
		scrollView.backgroundColor = .green
		return scrollView
	}()

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0.5
		layout.minimumInteritemSpacing = 0.5
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

		let collectionView = UICollectionView(frame: viewFrame, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
		return collectionView
	}()

	private lazy var threeColumnGridViewController: ThreeСolumnGridViewController = {
		let controller = ThreeСolumnGridViewController()
		controller.transitioningDelegate = self
		controller.modalPresentationStyle = .custom
		return controller
	}()

	// MARK: - Private types

	private enum Section {
		case first
		case second
		case third
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension FiveСolumnGridViewController: UIViewControllerTransitioningDelegate {

	func animationController(forPresented presented: UIViewController,
							 presenting: UIViewController,
							 source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		zoomPresentAnimation
	}

	func interactionControllerForPresentation(
		using animator: UIViewControllerAnimatedTransitioning
	) -> UIViewControllerInteractiveTransitioning? {
		zoomInteractiveTransitioning
	}
}

// MARK: - UICollectionViewDelegate

extension FiveСolumnGridViewController: UICollectionViewDelegate {

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		currentScrollViewYContentOffset = scrollView.contentOffset.y
	}
}

// MARK: - UIScrollViewDelegate

extension FiveСolumnGridViewController: UIScrollViewDelegate {

	func viewForZooming(in scrollView: UIScrollView) -> UIView? { collectionView }

	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		guard let pinchLocation = scrollView.pinchGestureRecognizer?.location(in: self.view) else { return }

		let offset = calculateOffset(
			zoomScale: finalZoomScale,
			contentSize: viewFrame.size * finalZoomScale,
			by: change(pinchLocation: pinchLocation)
		)

		let previewOrigin = CGPoint(
			x: offset.x / finalZoomScale + 0.6,
			y: offset.y / finalZoomScale + currentScrollViewYContentOffset
		)

		firstCellAfterZoom = cell(by: previewOrigin)

		guard let firstCellOriginAfterZoom = firstCellAfterZoom?.frame.origin,
			  let lastCellOriginAfterZoom = cell(
				by: CGPoint(
					x: previewOrigin.x + (itemWidth * 3),
					y: previewOrigin.y + itemWidth * 7
				)
			  )?.frame.origin else {
			return
		}

		let lowerRightCornerOfLastCell = lastCellOriginAfterZoom + itemWidth
		let sizeOfPreview = lowerRightCornerOfLastCell - firstCellOriginAfterZoom

		zoomPresentAnimation.initialFrame = CGRect(
			origin: firstCellOriginAfterZoom,
			size: CGSize(width: sizeOfPreview.x, height: sizeOfPreview.y)
		)

		present(threeColumnGridViewController, animated: true)
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		guard let pinchGestureRecognizer = scrollView.pinchGestureRecognizer else { return }
		let pinchLocation = pinchGestureRecognizer.location(in: view)
		let zoomScale = scrollView.zoomScale

		let newPinchLocation = change(pinchLocation: pinchLocation)

		scrollView.contentOffset = calculateOffset(
			zoomScale: zoomScale,
			contentSize: scrollView.contentSize,
			by: newPinchLocation
		)

		zoomPresentAnimation.scaleToView(
			by: zoomScale,
			origin: view.convert(
				firstCellAfterZoom?.frame.origin ?? .zero,
				from: collectionView
			)
		)

		zoomInteractiveTransitioning.update((zoomScale - 1) / (finalZoomScale - 1))
	}

	func scrollViewDidEndZooming(_ scrollView: UIScrollView,
								 with view: UIView?,
								 atScale scale: CGFloat) {
		if scale - 1 < 0.5 {
			zoomInteractiveTransitioning.cancel()
		} else {
			zoomInteractiveTransitioning.finish()
		}
	}
}

// MARK: - UICollectionViewDataSource

extension FiveСolumnGridViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int { 123 }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		cell.backgroundColor = .red
		let label = UILabel()
		label.text = "\(indexPath.row)(\(indexPath.row / 5)|\(indexPath.row % 5))"
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .white
		label.textAlignment = .center
		cell.backgroundView = label
		return cell
	}
}

// MARK: - Private

// MARK: Helper methods

private extension FiveСolumnGridViewController {

	func change(pinchLocation: CGPoint) -> CGPoint {
		var newLocation = CGPoint(x: 0, y: pinchLocation.y)

		switch section(for: pinchLocation) {
		case .first: newLocation.x = 0
		case .second: newLocation.x = viewFrame.midX
		case .third: newLocation.x = viewFrame.width
		case .none: return .zero
		}

		return newLocation
	}

	func calculateOffset(zoomScale: CGFloat,
						 contentSize: CGSize,
						 by pinchLocation: CGPoint) -> CGPoint {

		let offsetX = contentSize.width - (pinchLocation.x + (viewFrame.width - pinchLocation.x) * zoomScale)
		let offsetY = contentSize.height - (pinchLocation.y + (viewFrame.height - pinchLocation.y) * zoomScale)

		return CGPoint(x: offsetX, y: offsetY)
	}

	private func section(for pinchLocation: CGPoint) -> Section? {
		if pinchLocation.x > itemWidth && pinchLocation.x < itemWidth * 4 {
			return .second
		} else if pinchLocation.x < itemWidth {
			return .first
		} else if pinchLocation.x > itemWidth * 4 {
			return .third
		}

		return .none
	}

	func cell(by point: CGPoint) -> UICollectionViewCell? {
		let visibleCells = collectionView.visibleCells

		for cell in visibleCells { if CGRectContainsPoint(cell.frame, point) { return cell } }

		return nil
	}
}

// MARK: Setup UI

private extension FiveСolumnGridViewController {

	func setupUI() {
		view.backgroundColor = .blue
		addScrollView()
		addCollectionView()
	}

	func addScrollView() {
		view.addSubview(scrollView)

		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	func addCollectionView() {
		scrollView.addSubview(collectionView)
	}
}
