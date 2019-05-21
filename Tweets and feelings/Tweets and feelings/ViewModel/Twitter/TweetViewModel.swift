//
//  TweetViewModel.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/21/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Foundation

struct TweetViewModel {
	var tweet: Tweet? {
		didSet {
			self.setBasicDetails?(tweet?.user?.name ?? "", "@\(tweet?.user?.screen_name ?? "")", tweet?.text ?? "", tweet?.user?.profile_background_image_url ?? "")
		}
	}
	
	var sentiment: Sentiment? {
		didSet {
			self.setSentimentDetails?("Score: \(sentiment?.score ?? 0.0)", "Magniture: \(sentiment?.magnitude ?? 0.0)", sentiment?.getFeeling() ?? "")
		}
	}
	
	init() {}
	
	var setBasicDetails     : ((String, String, String, String) -> Void)? 	// 	username, screenName, tweetContent, userImageUrl
	var setSentimentDetails : ((String, String, String) -> Void)? 		    // 	scoreString, magnitudeString, feeling
}
