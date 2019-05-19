//
//  Sentiment.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class Sentiment: NSObject, Mappable {
	var magnitude     	: Float?
	var score 			: Float?
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		magnitude		<- map["magnitude"]
		score	 		<- map["score"]
	}
}
