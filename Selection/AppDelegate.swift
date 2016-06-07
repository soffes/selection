//
//  AppDelegate.swift
//  Selection
//
//  Created by Sam Soffes on 11/12/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder {

	// MARK: - Properties

	var window: UIWindow? = {
		let window = UIWindow()
		window.rootViewController = UINavigationController(rootViewController: TextViewController())
		return window
	}()
}


extension AppDelegate: UIApplicationDelegate {
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}
