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
//		getBearerTokenRequest()
		getTweetsForUsernameRequest(username: "RobertDowneyJr")
	}

	func getBearerTokenRequest() {
		let httpService = HTTPService()
		httpService.postGetTweeterBearer(onSuccess: { (token) in
			print("Twitter Bearer Token: \(token.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
	
	func getTweetsForUsernameRequest(username: String) {
		let httpService = HTTPService()
		httpService.getTweetsForUsername(screenName: username, onSuccess: { (tweets) in
			for tweet in tweets {
				print("Tweet: \(tweet.toJSON())")
				self.getSentimentAnylisisForTweetRequest(tweet: tweet)
			}
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
	
	func getSentimentAnylisisForTweetRequest(tweet: Tweet) {
		let httpService = HTTPService()
		httpService.postAnalyseSentiment(analysingString: tweet.text, onSuccess: { (googleSentimentAnylise) in
			print("Google Sentiment Analyse: \(googleSentimentAnylise.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
		

}
