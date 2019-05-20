//
//  TweeterUser.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import ObjectMapper

class TweeterUser: NSObject, Mappable {
	var name          					: String = ""
	var screen_name          			: String = ""
	var profile_background_image_url	: String = ""
	
	required init?(map: Map) { }
	
	func mapping(map: Map) {
		name 							<- map["name"]
		screen_name 					<- map["screen_name"]
		profile_background_image_url 	<- map["profile_background_image_url"]
	}
}
