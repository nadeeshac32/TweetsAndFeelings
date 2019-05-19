//
//  Text.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class Text: NSObject, Mappable {
	var content			: String = ""
	var beginOffset		: Float?
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		content			<- map["content"]
		beginOffset		<- map["beginOffset"]
	}
}
