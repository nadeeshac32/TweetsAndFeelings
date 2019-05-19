//
//  HTTPResponse.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class HTTPResponse: NSObject {
	
	var responseStatus  : Bool  = true
	var responseResult  : JSON?
	var responseError   : RestClientError?
	
	init(status: Bool, result: JSON? = nil, error: RestClientError? = nil) {
		self.responseStatus     = status
		self.responseResult     = result
		self.responseError      = error
	}
	
	init(result: JSON? = nil, error: RestClientError? = nil) {
		self.responseResult     = result
		self.responseError      = error
	}
}
