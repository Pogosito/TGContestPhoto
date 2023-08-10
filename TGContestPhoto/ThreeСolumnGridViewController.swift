//
//  ThreeСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ThreeСolumnGridViewController: UIViewController {
	
	lazy var zoomTransitioningDelegate = ZoomTransitioningDelegate(
		previewRect: previewRect,
		pinchLocation: pinchLocation
	)
	
	// MARK: - Private properties
	
	private let cellId: String = "collectionCellId"
	private let previewRect: CGRect
	private let pinchLocation: CGPoint
	
	private var interactionController: UIPercentDrivenInteractiveTransition?
	
	private lazy var zoomOutTransitionDelegate = transitioningDelegate as? ZoomTransitioningDelegate
	private lazy var itemWidth: CGFloat = (view.frame.width * (3 / 5) - 2) / 3
	
	// MARK: UI
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

		let collectionView = UICollectionView(frame: CGRect(
			origin: .zero,
			size: CGSize(width: view.frame.width * (3 / 5), height: view.frame.height)
		), collectionViewLayout: layout)

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
		pinchLocation: CGPoint
	) {
		self.previewRect = previewRect
		self.pinchLocation = pinchLocation
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .custom
		transitioningDelegate = zoomTransitioningDelegate
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .red
		setupUI()
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

		if sender.scale > 1.0 { return }

		switch sender.state {
		case .began:
			interactionController = UIPercentDrivenInteractiveTransition()
			zoomOutTransitionDelegate?.interactiveTransition = interactionController
			dismiss(animated: true)
		case .changed: zoomOutTransitionDelegate?.interactiveTransition?.update((1 - sender.scale) / (3.0 / 5.0))
		case .ended, .possible, .failed, .cancelled:
			(1 - sender.scale) / (3.0 / 5.0) > 0.25
			? zoomOutTransitionDelegate?.interactiveTransition?.finish()
			: zoomOutTransitionDelegate?.interactiveTransition?.cancel()
		@unknown default: return
		}
	}
}

// MARK: Setup UI

private extension ThreeСolumnGridViewController {

	func setupUI() {
		view.addSubview(collectionView)
	}
}
