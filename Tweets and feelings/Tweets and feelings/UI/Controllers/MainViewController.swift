//
//  MainViewController.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func buttonTapped(_ sender: Any) {
		let httpService = HTTPService()
		httpService.postGetTweeterBearer(onSuccess: { (token) in
			print("twitter token type: \(token.token_type)")
			print("twitter access token: \(token.access_token)")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}

//		httpService.getTweetsForUsername(screenName: "RobertDowneyJr", onSuccess: { (tweets) in
//			for tweet in tweets {
//				print("Tweet: \(tweet.toJSON())")
//			}
//		}) { (error) in
//			print("Rest Client Error: \(error)")
//		}
		
	}
	

}
