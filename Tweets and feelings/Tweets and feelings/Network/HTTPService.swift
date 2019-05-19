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
			"Content-Type"                      : "application/json"
		]
	}
	
	func genericRequest<T: BaseMappable>(method: HTTPMethod, parameters: [String: AnyObject]?, contextPath: String, responseType: T.Type, onError: ErrorCallback? = nil, completionHandler: @escaping (T?, [T]?) -> Void) {
		let urlString                           = "\(self.baseUrl!)/\(contextPath)"
		self.parameters?.update(other: parameters)
		
		let request: DataRequest!
		
		if method == .get {
			request = Alamofire.request(urlString, method: method, encoding: JSONEncoding.default, headers: self.headers!)
		} else {
			request = Alamofire.request(urlString, method: method, parameters: self.parameters!, encoding: JSONEncoding.default, headers: self.headers!)
		}
		
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
								print("result?.rawString() : \(result?.rawString())")
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
			print("result?.rawString() : \(result?.rawString())")
			
			if let jsonString = result?.rawString() {
				if let responseObject = Mapper<T>().map(JSONString: jsonString) {
					completionHandler(responseObject, nil)
					return
				}
			} else if let jsonArray = resultArray {
				let itemsArray = Mapper<T>().mapArray(JSONArray: jsonArray)
				completionHandler(nil, itemsArray)
				return
			} else {
				let exception                   = RestClientError.JsonParseError(errorMessage: AppConfig.si.jsonParseError.msg)
				onError?(exception)
				return
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
		
		genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: TwitterToken.self, onError: onError, completionHandler: { (twitterToken, _) in
			if let twitterToken = twitterToken {
				onSuccess?(twitterToken)
				return
			}
		})
	}
	
	func getTweetsForUsername(method: HTTPMethod? = .get, screenName: String, onSuccess: ((_ tweets: [Tweet]) -> Void)?, onError: ErrorCallback?) {
		self.baseUrl                            = AppConfig.si.baseUrlTwitter
		let contextPath                         = "1.1/statuses/user_timeline.json?screen_name=\(screenName)&count=1"
		self.headers?["Authorization"]    		= "Bearer \(String(describing: AppConfig.si.twitterBearer!))"
		
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
		self.baseUrl                            = AppConfig.si.baseUrlGoogleDocAnalyse
		let contextPath                         = "documents:analyzeSentiment?key=\(AppConfig.si.googleAPIKey!)"
		
		let document  		: [String : AnyObject]  = [
			"type"     		: "PLAIN_TEXT" as AnyObject,
			"language" 		: "en" as AnyObject,
			"content" 		: "\(analysingString)" as AnyObject
		]
		
		let parameters    	: [String : AnyObject]  = [
			"document"     	: "\(document)" as AnyObject,
			"encodingType" 	: "UTF8" as AnyObject
		]
		
		genericRequest(method: method!, parameters: parameters, contextPath: contextPath, responseType: GoogleSentiment.self, onError: onError, completionHandler: { (googleSentiment, _) in
			if let googleSentiment = googleSentiment {
				onSuccess?(googleSentiment)
				return
			}
		})
	}
	
	
}
