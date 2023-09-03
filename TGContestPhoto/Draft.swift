//
//  Draft.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 25.06.2023.
//

import UIKit

// MARK: - ViewController2

/*
 
 Надо решить задачу без помощи конвертации, так как в случае с переходом у контроллеров нету общего view на котором они лежат ??? (попробовать UIScreen.keywindow ...)
 */

final class ViewController2: UIViewController {

	let someButton = UIButton(frame: .init(x: 100, y: 200, width: 100, height: 100))

	let brownView = UIView(frame: .init(x: 200, y: 200, width: 150, height: 700))
	let greenView = UIView(frame: .init(x: 220, y: 220, width: 70, height: 70))
//	let
	let line = UIView(frame: .init(x: 0, y: 20, width: 100, height: 5))

	let slider = UISlider(frame: .init(x: 10, y: 800, width: UIScreen.main.bounds.width - 50, height: 10))

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .gray

		brownView.backgroundColor = .brown
		greenView.backgroundColor = .green

		slider.minimumValue = 1.0
		slider.maximumValue = 3.0

		view.addSubview(slider)
		view.addSubview(brownView)
		view.addSubview(greenView)

		slider.addTarget(self, action: #selector(sliderDidChanged), for: .valueChanged)

//		let greenAnchorPoint = CGPoint(
//			x: (brownView.anchorPoint.x * brownView.frame.width - 20) / greenView.frame.width,
//			y: (brownView.anchorPoint.y * brownView.frame.height - 20) / greenView.frame.height
//		)
//
		greenView.setAnchorPoint(CGPoint(x: 0.3, y: 0.3))

		let anchorPointXOfGreenViewInParenCoordSpace = greenView.frame.origin.x + (greenView.anchorPoint.x * greenView.frame.width)
		let anchorPointXOfGreenViewInBrownView = anchorPointXOfGreenViewInParenCoordSpace - brownView.frame.origin.x

		let anchorPointYOfGreenViewInParenCoordSpace = greenView.frame.origin.y + (greenView.anchorPoint.y * greenView.frame.height)
		let anchorPointYOfGreenViewInBrownView = anchorPointYOfGreenViewInParenCoordSpace - brownView.frame.origin.y

		let brownAnchorPoint = CGPoint(
			x: anchorPointXOfGreenViewInBrownView / brownView.frame.width,
			y: anchorPointYOfGreenViewInBrownView / brownView.frame.height
		)

		brownView.setAnchorPoint(brownAnchorPoint)

//		print(brownView.convert(CGPoint.zero, to: greenView))
	}

	@objc func sliderDidChanged() {

		let sliderValue = CGFloat(slider.value)

		brownView.transform = CGAffineTransform(scaleX: sliderValue, y: sliderValue)
		greenView.transform = CGAffineTransform(scaleX: sliderValue, y: sliderValue)
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
