//
//  Draft.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 25.06.2023.
//

import UIKit

// MARK: - ViewController2

final class ViewController2: UIViewController {

	let someButton = UIButton(frame: .init(x: 100, y: 200, width: 100, height: 100))

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .gray
		view.addSubview(someButton)
		someButton.backgroundColor = .blue
		someButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}

	@objc func buttonTapped() {
		someButton.transform = CGAffineTransform(scaleX: 2, y: 2)
		print(someButton.frame)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		someButton.transform = someButton.transform.scaledBy(x: 1.0 / 2.0, y: 1.0 / 2.0)
		print(someButton.frame)
	}
}
