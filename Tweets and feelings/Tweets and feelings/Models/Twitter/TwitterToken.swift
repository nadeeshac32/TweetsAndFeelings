//
//  TwitterToken.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class TwitterToken: NSObject, Mappable {
	var token_type    	: String = ""
	var access_token	: String = ""
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		token_type		<- map["token_type"]
		access_token	<- map["access_token"]
	}
}
