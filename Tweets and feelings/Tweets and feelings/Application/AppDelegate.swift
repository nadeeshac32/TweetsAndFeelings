//
//  AppDelegate.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/17/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	let manager                 = NetworkReachabilityManager(host: "www.apple.com")
	let defaults                = UserDefaults.standard
	var language:NSString?      = "" {
		didSet { AppConfig.si.setLng(newLanguage: language!) }
	}
	
	func showAlert(title: String! = nil, message: String! = nil, alertAction: UIAlertAction! = nil) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		if alertAction != nil {
			ac.addAction(alertAction)
		} else {
			ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
		}
		
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			topController.present(ac, animated: true, completion: nil)
		}
	}
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		URLCache.shared = AppConfig.si.urlCache
		
		var style                               = ToastStyle()
		style.messageColor                      = .white
		style.backgroundColor                   = UIColor.black.withAlphaComponent(0.7)
		ToastManager.shared.style               = style
		ToastManager.shared.position            = .center
		ToastManager.shared.duration            = 4.0
		ToastManager.shared.isTapToDismissEnabled = true
		
		let defaultLang = AppConfig.si.defaultLang
		let language    = defaults.string(forKey: "language") ?? defaultLang
		self.language   = language! as NSString
		
		manager?.listener = { status in
			if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
				self.showAlert(title: AppConfig.si.networkFailedAlertTitle, message: AppConfig.si.networkFailedAlertMsg, alertAction: nil)
			} else {
				if var topController = UIApplication.shared.keyWindow?.rootViewController {
					while let presentedViewController = topController.presentedViewController {
						topController = presentedViewController
					}
					topController.dismiss(animated: true, completion: nil)
				}
			}
		}
		manager?.startListening()
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

