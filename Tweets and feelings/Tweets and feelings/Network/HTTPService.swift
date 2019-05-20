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
	var baseUrl                                 	: String?
	var parameters                              	: Parameters?
	var headers                                 	: [String : String]?
	
	init(baseUrl: String! = AppConfig.si.baseUrl) {
		self.baseUrl                            	= baseUrl
		parameters                              	= [:]
		headers                                 	= [
			"Content-Type"                      	: "application/json"
		]
	}
	
	func genericRequest<T: BaseMappable>(method: HTTPMethod, parameters: Parameters?, contextPath: String, responseType: T.Type, onError: ErrorCallback? = nil, completionHandler: @escaping (T?, [T]?) -> Void) {
		
		let urlString                           	= "\(self.baseUrl!)/\(contextPath)"
		self.parameters?.update(other: parameters)
		let request 								= Alamofire.request(urlString,
																	method: method,
																	parameters: method == .get ? nil : self.parameters!,
																	encoding: JSONEncoding.default,
																	headers: self.headers!)
		
		request.responseJSON { response in
			var exception                       	: RestClientError?
			if let errorMessage = response.error?.localizedDescription {
				exception                       	= RestClientError.AlamofireError(errorMessage: errorMessage)
			} else {
				if let _ = response.data {
					if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! < 300 {
						if let dataArray = response.result.value as? [Dictionary<String, Any>] {
							let responseItemsArray	= Mapper<T>().mapArray(JSONArray: dataArray)
							completionHandler(nil, responseItemsArray)
							return
						} else if let dataObject = response.result.value as? Dictionary<String, Any>, let responseObject = Mapper<T>().map(JSON: dataObject) {
							completionHandler(responseObject, nil)
							return
						} else {
							exception       		= RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
						}
					} else if let dataObject = response.result.value as? Dictionary<String, Any> {
						exception           		= RestClientError.init(jsonResult: dataObject)
					} else {
						exception       			= RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
					}
				} else {
					exception             			= RestClientError.EmptyDataError()
				}
			}
			
			if let error = exception {
				print("")
				print("request                      : \(request.debugDescription)")
				print("status code                  : \(String(describing: response.response?.statusCode))")
				print("error                        : \(error)")
				print("contextPath                  : \(contextPath)")
				print("parameters                   : \(String(describing: self.parameters))")
				print("")
				onError?(error)
				return
			}
		}
	}
}

extension HTTPService: TwitterAPIProtocol {
	func postTweeterBearer(method: HTTPMethod? = .post, onSuccess: ((TwitterToken) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                            	= AppConfig.si.baseUrlTwitter
		let contextPath                         	= "oauth2/token?grant_type=client_credentials"
		
		let basicAuthentication 					= "\(AppConfig.si.twitterAPIKey!):\(AppConfig.si.twitterAPISecretKey!)".data(using: .utf8) ?? Data(base64Encoded: "")
		let basicAuthenticationBase64				= basicAuthentication!.base64EncodedString(options: [])
		self.headers?["Authorization"]    			= "Basic \(String(describing: basicAuthenticationBase64))"
		
		genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: TwitterToken.self, onError: onError, completionHandler: { (twitterToken, _) in
			if let twitterToken = twitterToken {
				onSuccess?(twitterToken)
				return
			}
		})
	}
	
	func getTweetsForUsername(method: HTTPMethod? = .get, screenName: String, onSuccess: ((_ tweets: [Tweet]) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                                = AppConfig.si.baseUrlTwitter
		let contextPath                             = "1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=4"
		self.headers?["Authorization"]    		    = "Bearer \(String(describing: AppConfig.si.twitterBearer!))"
		
		genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: Tweet.self, onError: onError, completionHandler: { (_, tweets) in
			if let tweets = tweets {
				onSuccess?(tweets)
				return
			}
		})
	}
}

extension HTTPService: GoogleAPIProtocol {
	func postAnalyseSentiment(method: HTTPMethod? = .post, analysingString: String, onSuccess: ((GoogleSentiment) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                                = AppConfig.si.baseUrlGoogleDocAnalyse
		let contextPath                             = "documents:analyzeSentiment?key=\(AppConfig.si.googleAPIKey!)"
		let parameters : Parameters  		    	= [
			"document":[
				"type":"PLAIN_TEXT",
				"language"	: "EN",
				"content"	:"\(analysingString)"],
			"encodingType":"UTF8"
		]
		
		genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: GoogleSentiment.self, onError: onError, completionHandler: { (googleSentiment, _) in
			if let googleSentiment = googleSentiment {
				onSuccess?(googleSentiment)
				return
			}
		})
	}
}
