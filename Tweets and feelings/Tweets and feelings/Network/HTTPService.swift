//
//  HTTPService.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Alamofire
import ObjectMapper

class HTTPService: NSObject {
	var baseUrl                                 : String?
	var parameters                              : [String : AnyObject]?
	var headers                                 : [String : String]?
	
	init(baseUrl: String! = AppConfig.si.baseUrl) {
		self.baseUrl                            = baseUrl
		parameters                              = [:]
		headers                                 = [
			"Content-Type"                      : "application/json",
			"Accept"							: "*/*"
		]
	}
	
	func genericRequest(method: HTTPMethod, parameters: [String: AnyObject]?, contextPath: String, onError: ErrorCallback? = nil, completionHandler: @escaping (JSON?, [[String: Any]]?) -> Void) {
		let urlString                           = "\(self.baseUrl!)/\(contextPath)"
		self.parameters?.update(other: parameters)
		
		let request = Alamofire.request(urlString, method: method, parameters: self.parameters!, encoding: JSONEncoding.default, headers: self.headers!)
		
			request.responseJSON { response in
			
			var exception                       : RestClientError?
			var result                          : JSON?
			var resultArray                     : [Dictionary<String, Any>]?
			
			if let errorMessage = response.error?.localizedDescription {
				exception                       = RestClientError.AlamofireError(errorMessage: errorMessage)
			} else {
				do {
					
					if let data = response.data {
						if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! < 300 {
							if let dataArray = response.result.value as? [Dictionary<String, Any>] {
								resultArray				= dataArray
							} else {
								let jsonResult: JSON    = try JSON(data: data)
								result 					= jsonResult
							}
						} else {
							let jsonResult: JSON    	= try JSON(data: data)
							exception           		= RestClientError.init(jsonResult: jsonResult)
						}
					} else {
						exception             	= RestClientError.EmptyDataError()
					}
				} catch {
					exception                   = RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
				}
			}
			if let error = exception {
				print("")
				print("request      : \(request.debugDescription)")
				print("status code  : \(String(describing: response.response?.statusCode))")
				print("error        : \(error)")
				print("contextPath  : \(contextPath)")
				print("parameters   : \(String(describing: self.parameters))")
				print("")
				onError?(error)
				return
			}
			
			if let jsonString = result {
				completionHandler(jsonString, nil)
				return
			}
			
			if let jsonArray = resultArray {
				completionHandler(nil, jsonArray)
				return
			}
		}
	}
}


extension Dictionary {
	mutating func update(other: Dictionary?) {
		if other != nil {
			for (key,value) in other! {
				self.updateValue(value, forKey:key)
			}
		}
	}
}


extension HTTPService: TwitterAPIProtocol {
	func postGetTweeterBearer(method: HTTPMethod? = .post, onSuccess: ((TwitterToken) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                            = AppConfig.si.baseUrlTwitter
		let contextPath                         = "oauth2/token?grant_type=client_credentials"
		
		let basicAuthentication 				= "\(AppConfig.si.twitterAPIKey!):\(AppConfig.si.twitterAPISecretKey!)".data(using: .utf8) ?? Data(base64Encoded: "")
		let basicAuthenticationBase64			= basicAuthentication!.base64EncodedString(options: [])
		self.headers?["Authorization"]    		= "Basic \(String(describing: basicAuthenticationBase64))"
		
		genericRequest(method: method!, parameters: nil, contextPath: contextPath, onError: onError, completionHandler: { (responseJson, responseJsonDictArray) in
			if let jsonString = responseJson?.rawString(), let twitterToken = Mapper<TwitterToken>().map(JSONString: jsonString) {
				onSuccess?(twitterToken)
				return
			} else {
				let exception                   = RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
				onError?(exception)
				return
			}
		})
	}
	
	func getTweetsForUsername(method: HTTPMethod? = .get, screenName: String, onSuccess: ((_ tweets: [Tweet]) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                            = AppConfig.si.baseUrlTwitter
		let contextPath                         = "1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=2"
		self.headers?["Authorization"]    		= "Bearer \(String(describing: AppConfig.si.twitterBearer!))"
		
		genericRequest(method: method!, parameters: nil, contextPath: contextPath, onError: onError, completionHandler: { (responseJsonString, responseJsonDictArray) in
			if let jsonDictArray = responseJsonDictArray {
				let itemsArray = Mapper<Tweet>().mapArray(JSONArray: jsonDictArray)
				onSuccess?(itemsArray)
				return
			} else {
				let exception                   = RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
				onError?(exception)
				return
			}
		})
	}
	
	
}
