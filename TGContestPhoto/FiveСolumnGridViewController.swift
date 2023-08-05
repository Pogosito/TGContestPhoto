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

	private var currentScrollViewYContentOffset: CGFloat = 0
	private var interactionController: UIPercentDrivenInteractiveTransition?

	private lazy var itemWidth: CGFloat = (view.frame.width - (4 * 1)) / 5
	private lazy var finalZoomScale: Double = 5.0 / 3.0

	// MARK: UI

	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

		let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)

		let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(
			target: self,
			action: #selector(didPinch(_:))
		)

		collectionView.addGestureRecognizer(pinchGesture)
		return collectionView
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
}

// MARK: - UICollectionViewDelegate

extension FiveСolumnGridViewController: UICollectionViewDelegate {

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		currentScrollViewYContentOffset = scrollView.contentOffset.y
	}
}

// MARK: - UICollectionViewDataSource

extension FiveСolumnGridViewController: UICollectionViewDataSource {

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

// MARK: Actions

private extension FiveСolumnGridViewController {

	@objc func didPinch(_ sender: UIPinchGestureRecognizer) {

		if sender.scale < 1.0 { return }

		switch sender.state {
		case .began: began(pinch: sender)
		case .changed:
			interactionController?.update((sender.scale - 1) / finalZoomScale)
		case .ended, .possible, .failed, .cancelled:
			(sender.scale - 1) / finalZoomScale > 0.25
			? interactionController?.finish()
			: interactionController?.cancel()
		@unknown default: return
		}
	}
}

// MARK: Helper methods

private extension FiveСolumnGridViewController {

	func began(pinch: UIPinchGestureRecognizer) {

		let pinchLocation = change(pinchLocation: pinch.location(in: view))

		let x = view.frame.origin.x - ((view.frame.origin.x + pinchLocation.x) - (pinchLocation.x * finalZoomScale))
		let y = view.frame.origin.y - ((view.frame.origin.y + pinchLocation.y) - (pinchLocation.y * finalZoomScale))

		let firstPointOnScreenAfterZoom = CGPoint(
			x: abs(x / finalZoomScale),
			y: abs(y / finalZoomScale) - view.safeAreaInsets.top
		)

		let numberOfFirstLineInCollectionAfterZoom = (firstPointOnScreenAfterZoom.y / itemWidth).rounded(.down)
		let previewOriginY = (numberOfFirstLineInCollectionAfterZoom) * (itemWidth + 1)

		let previewRect: CGRect = CGRect(
			origin: CGPoint(x: 83, y: previewOriginY + view.safeAreaInsets.top),
			size: .init(width: 200, height: 200)
		)

		let threeColumnGridViewController = ThreeСolumnGridViewController(
			previewRect: previewRect,
			pinchLocation: pinchLocation
		)

		interactionController = UIPercentDrivenInteractiveTransition()
		threeColumnGridViewController.zoomTransitioningDelegate.interactiveTransition = interactionController

		present(threeColumnGridViewController, animated: true)
	}

	func change(pinchLocation: CGPoint) -> CGPoint {
		var newLocation = CGPoint(x: 0, y: pinchLocation.y)

		switch section(for: pinchLocation) {
		case .first: newLocation.x = 0
		case .second: newLocation.x = view.frame.midX
		case .third: newLocation.x = view.frame.width
		case .none: return .zero
		}

		return newLocation
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
		for cell in visibleCells {

			if CGRectContainsPoint(cell.frame, point) {
				return cell
			}
		}

		return nil
	}
}

// MARK: Setup UI

private extension FiveСolumnGridViewController {

	func setupUI() {
		view.addSubview(collectionView)
	}
}
