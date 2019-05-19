//
//  AppConfig.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import CoreLocation

let configFileName:String = "Configuration"

class AppConfig: NSObject, CLLocationManagerDelegate {
	
	static let si               = AppConfig()
	private var configDict      : NSDictionary?
	
	let defaults            	= UserDefaults.standard
	
	var appName: String! {
		guard let string        = getValue(key: "appName") else { return "" }
		return (string as! String)
	}
	
	// MARK: - url variables
	var url: NSDictionary! {
		guard let urlArray = getValue(key: "url") else { return [:] }
		return (urlArray as! NSDictionary)
	}
	
	var baseUrl: String! {
		guard let string = url["domain"] else { return "" }
		return (string as! String)
	}
	
	var baseUrlTwitter: String! {
		guard let string = url["domainTwitter"] else { return "" }
		return (string as! String)
	}
	
	var baseUrlGoogleDocAnalyse: String! {
		guard let string = url["domainGoogleDocAnalyse"] else { return "" }
		return (string as! String)
	}
	
	
	// MARK: - API keys
	var apiKeys: NSDictionary! {
		guard let keysArray = getValue(key: "apiKeys") else { return [:] }
		return (keysArray as! NSDictionary)
	}
	
	var twitterAPIKey: String! {
		guard let string = apiKeys["twitterAPIKey"] else { return "" }
		return (string as! String)
	}
	
	var twitterAPISecretKey: String! {
		guard let string = apiKeys["twitterAPISecretKey"] else { return "" }
		return (string as! String)
	}
	
	var twitterBearer: String! {
		guard let string = apiKeys["twitterBearer"] else { return "" }
		return (string as! String)
	}
	
	var googleAPIKey: String! {
		guard let string = apiKeys["googleAPIKey"] else { return "" }
		return (string as! String)
	}
	

	
	// MARK: - language variables
	var language                = ""
	
	var defaultLang: String! {
		guard let lang = getValue(key: "defaultLang") else { return "" }
		return (lang as! String)
	}
	
	internal func setLng( newLanguage: NSString) {
		self.language           = newLanguage as String
		defaults.set(language, forKey: "language")
	}
	
	var languages: NSDictionary! {
		guard let langs = getValue(key: "languages") else { return [:] }
		return (langs as! NSDictionary)
	}
	
	var languageStrings: NSDictionary! {
		guard let langStrings = languages[language] else { return [:] }
		return (langStrings as! NSDictionary)
	}
	
	var networkFailedAlertTitle:String! {
		guard let string = languageStrings["networkFailedAlertTitle"] else { return "" }
		return (string as! String)
	}
	
	var networkFailedAlertMsg:String! {
		guard let string = languageStrings["networkFailedAlertMsg"] else { return "" }
		return (string as! String)
	}
	
	
	var somethingWentWrongAlertMsg:String! {
		guard let string = languageStrings["somethingWentWrongAlertMsg"] else { return "" }
		return (string as! String)
	}
	
	
	var tryAgainAlertMsg:String! {
		guard let string = languageStrings["tryAgainAlertMsg"] else { return "" }
		return (string as! String)
	}
	
	var pleaseTryAgainLaterAlertMsg:String! {
		guard let string = languageStrings["pleaseTryAgainLaterAlertMsg"] else { return "" }
		return (string as! String)
	}
	
	var pleaseFillTheUsernameAlertMsg:String! {
		guard let string = languageStrings["pleaseFillTheUsernameAlertMsg"] else { return "" }
		return (string as! String)
	}
	
	// MARK: - system variables
	var memoryCapacity:Int {
		guard let int = getValue(key: "memoryCapacity") else { return 0 }
		return (int as! Int) * 1024 * 1024
	}
	
	var diskCapacity:Int {
		guard let int = getValue(key: "diskCapacity") else { return 0 }
		return (int as! Int) * 1024 * 1024
	}
	
	var urlCache:URLCache {
		let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "TweetsAndFeelingsDiskpath")
		return cache
	}
	
	let screenSize                  : CGRect    = UIScreen.main.bounds
	
	//MARK: - Colors
	let colorPrimary                            = UIColor(hexString: "1da1f2")
	
	//MARK: - RestClientError constants
	var localErrors: NSDictionary! {
		guard let dict = getValue(key: "localErrors") else { return [:] }
		return (dict as! NSDictionary)
	}
	
	var jsonParseError: (code: Int, msg: String) {
		let dict    = localErrors["jsonParseError"] as! NSDictionary
		return (dict["code"] as! Int ,msg: dict["message"] as! String)
	}
	
	var undefinedError: (code: Int, msg: String) {
		let dict    = localErrors["undefinedError"] as! NSDictionary
		return (dict["code"] as! Int ,msg: dict["message"] as! String)
	}
	
	
	//MAEK: - Specific image names
	let default_ImageName           = "default_image"
	
	//MARK: - init
	override private init() {
		super.init()
		self.startCofigManager()
	}
	
	func startCofigManager() {
		if let plist = Plist(name: configFileName) {
			configDict = plist.getValuesInPlistFile()
		} else {
			print("AppConfig -> startManager : Unable to start")
		}
	}
	
	func getValue(key:String) -> AnyObject? {
		var value:AnyObject?
		if let dict = configDict {
			let keys = Array(dict.allKeys)
			//print("[Config] Keys are: \(keys)")
			if keys.count != 0 {
				for (_,element) in keys.enumerated() {
					//print("[Config] Key Index - \(index) = \(element)")
					if element as! String == key {
						//print("[Config] Found the Item that we were looking for for key: [\(key)]")
						value = dict[key]! as AnyObject
						break
					}
				}
				
				if value != nil {
					return value!
				} else {
					print("[AppConfig] WARNING: The Item for key '\(key)' does not exist! Please, check your spelling.")
					return .none
				}
			} else {
				print("[AppConfig] No Plist Item Found when searching for item with key: \(key). The Plist is Empty!")
				return .none
			}
		} else {
			print("[AppConfig] -> getValue : Unable to get Plist")
			return .none
		}
	}
	
}
