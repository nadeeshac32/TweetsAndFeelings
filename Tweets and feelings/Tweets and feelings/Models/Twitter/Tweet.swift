//
//  Tweet.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import ObjectMapper

class Tweet: NSObject, Mappable {
	var text          	: String = ""
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		text 			<- map["text"]
	}
}
