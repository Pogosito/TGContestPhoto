//
//  AppDelegate.swift
//  TGContestPhoto
//
//  Created by Pogos Anesyan on 24.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		window = UIWindow()
		window?.rootViewController = FiveСolumnGridViewController()
		window?.makeKeyAndVisible()
		return true
	}
}
