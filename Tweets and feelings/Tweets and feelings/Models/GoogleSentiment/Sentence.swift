//
//  Sentence.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class Sentence: NSObject, Mappable {
	var text          	: Text?
	var sentiment 		: Sentiment?
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		text 			<- map["text"]
		sentiment 		<- map["sentiment"]
	}
}
