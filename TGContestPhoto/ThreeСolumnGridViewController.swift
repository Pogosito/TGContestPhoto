//
//  ThreeСolumnGridViewController.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 12.07.2023.
//

import UIKit

final class ThreeСolumnGridViewController: UIViewController {

	var button: UIButton = UIButton(frame: .init(origin: .init(x: 30, y: 30), size: .init(width: 50, height: 50)))

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .purple
		view.alpha = 0.4
		button.backgroundColor = .red
		view.addSubview(button)
		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
	}

	@objc func tap() {
		dismiss(animated: true)
	}
}
