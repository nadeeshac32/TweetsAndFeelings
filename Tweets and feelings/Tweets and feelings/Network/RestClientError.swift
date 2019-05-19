//
//  RestClientError.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

typealias ErrorCallback             = (_ error: RestClientError) -> Void
typealias SuccessEmptyDataCallback  = () -> Void

public enum RestClientError: Error {
	case AlamofireError(errorMessage: String)
	
	case TwitterError(errorCode: Int, errorMessage: String)
	
	case GoogleError(errorCode: Int, errorMessage: String)
	
	case JsonParseError(errorMessage: String)
	
	case UndefinedError()
	
	case EmptyDataError()
}


extension RestClientError {
	init(jsonResult: JSON?) {
		if let googleErrorCode   	= jsonResult?["error"]["code"].intValue,
			let googleErrorMessage	= jsonResult?["error"]["message"].stringValue,
			googleErrorMessage != "" {

			self    				= .GoogleError(errorCode: googleErrorCode, errorMessage: googleErrorMessage)
		} else if let twitterErrorArray   = jsonResult?["errors"].arrayValue,
			twitterErrorArray.count > 0,
			let errorCode 			= twitterErrorArray[0]["code"].int,
			let message         	= twitterErrorArray[0]["message"].string,
			message != ""  {
			
			self    				= .TwitterError(errorCode: errorCode, errorMessage: message)
		} else {
			
			self                	= .UndefinedError()
		}
	}
}


//TODO: remove this description
extension RestClientError: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .AlamofireError(errorMessage)              : return    "Alamofire error -> message: \(errorMessage)"
		case let .TwitterError(errorCode, errorMessage)     : return    "TwitterError error -> code: \(errorCode), message: \(errorMessage)"
		case let .GoogleError(errorCode, errorMessage)      : return    "GoogleError error -> code: \(errorCode), message: \(errorMessage)"
		case let .JsonParseError(errorMessage)              : return    "Json Parse error -> message: \(errorMessage)"
		case .UndefinedError()                              : return    "Error Not Registered"
		case .EmptyDataError() 								: return 	"Error Response Empty"
		}
	}
}
