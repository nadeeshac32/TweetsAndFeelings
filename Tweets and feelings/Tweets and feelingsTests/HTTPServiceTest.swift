//
//  HTTPServiceTest.swift
//  Tweets and feelingsTests
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import XCTest

@testable import Tweets_and_feelings
class HTTPServiceTest: XCTestCase {

	var httpService: HTTPService!
	
    override func setUp() {
        httpService 	= HTTPService()
    }

    override func tearDown() {
        httpService 	= nil
    }

    func testGetTweetsForTweetExistingUsername() {
		let username = "RobertDowneyJr"		// Robert Downey Jr's Screen name
		
		let promise = expectation(description: "Get tweets for existing username")
		httpService.getTweetsForUsername(screenName: username, onSuccess: { (tweets) in
			if tweets.count > 0 {
				promise.fulfill()
			} else {
				XCTFail("Tweets count: zero")
			}
		}) { (error) in
			XCTFail("Error: \(error.description)")
		}
		wait(for: [promise], timeout: 6)
    }
	
	func testGetTweetsForTweetNonExistingUsername() {
		let username = "NonExistingUsername"

		let promise = expectation(description: "Get a RestClientTwitterError for non-existing username")
		httpService.getTweetsForUsername(screenName: username, onSuccess: { (tweets) in
			XCTFail("Shouldn't recieve a success response for non-existing username")
		}) { (error) in
			let tweeterErrorCodeForNonExistingPage = 34
			switch error {
			case .TwitterError(let errorCode, _):
				if errorCode == tweeterErrorCodeForNonExistingPage {
					promise.fulfill()
				} else{
					XCTFail("RestClientTwitterError is not for non existing user")
				}
				break
			default:
				XCTFail("Didn't recieve a RestClientTwitterError")
				break
			}
		}
		wait(for: [promise], timeout: 6)
	}

	func testPostAnalyseSentiment() {
		let googleSampleTestString 		= "Google, headquartered in Mountain View (1600 Amphitheatre Pkwy, Mountain View, CA 940430), unveiled the new Android phone for $799 at the Consumer Electronic Show. Sundar Pichai said in his keynote that users love their new Android phones."
		let documentSentimentMagnitude: Float 	= 0.6
		let documentSentimentScore 	  : Float	= 0.3
		
		let promise = expectation(description: "Get a the same sentiment result as in the Google sample test in the web site")
		httpService.postAnalyseSentiment(analysingString: googleSampleTestString, onSuccess: { (sentiment) in
			if let magnitude = sentiment.documentSentiment?.magnitude, magnitude == documentSentimentMagnitude, let score = sentiment.documentSentiment?.score, score == documentSentimentScore {
				promise.fulfill()
			} else {
				XCTFail("Didn't get the same result which was given in Google sample test in the web site")
			}
		}) { (error) in
			XCTFail("Error: \(error.description)")
		}
		wait(for: [promise], timeout: 6)
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
