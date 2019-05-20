//
//  TwitterAPIProtocol.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Alamofire

protocol TwitterAPIProtocol {
	func postTweeterBearer(method: HTTPMethod?, onSuccess: ((_ twitterToken: TwitterToken) -> Void)?, onError: ErrorCallback?)
	
	func getTweetsForUsername(method: HTTPMethod?, screenName: String, onSuccess: ((_ tweets: [Tweet]) -> Void)?, onError: ErrorCallback?)
}
