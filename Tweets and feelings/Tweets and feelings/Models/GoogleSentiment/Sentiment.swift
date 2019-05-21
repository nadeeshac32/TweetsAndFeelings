//
//  Sentiment.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class Sentiment: NSObject, Mappable {
	var magnitude     	: Float? = 0.0
	var score 			: Float? = 0.0
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		magnitude		<- map["magnitude"]
		score	 		<- map["score"]
	}
	
	func getFeeling() -> String {
		var feeling: String = ""
		if let magnitude = magnitude, magnitude > 0.15 {
			feeling 	+= "Clearly "
		}
		
		if let score = score {
			if score > 0.25 {
				feeling 	+= "Positive"
			} else if score > -0.25 {
				feeling 	+= "Neutral"
			} else {
				feeling 	+= "Negative"
			}
		}
		
		return feeling
	}
}
