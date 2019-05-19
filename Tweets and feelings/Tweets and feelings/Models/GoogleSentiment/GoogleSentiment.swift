//
//  GoogleSentiment.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class GoogleSentiment: NSObject, Mappable {
	var documentSentiment 	: Sentiment?
	var language			: String = ""
	var sentences 			: [Sentence]?
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		documentSentiment	<- map["documentSentiment"]
		language 			<- map["language"]
		sentences 			<- map["sentences"]
	}
}
