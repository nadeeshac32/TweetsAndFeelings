//
//  GoogleAPIProtocol.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Alamofire

protocol GoogleAPIProtocol {
	func postAnalyseSentiment(method: HTTPMethod?, analysingString: String, onSuccess: ((_ googleSentiment: GoogleSentiment) -> Void)?, onError: ErrorCallback?)
}
