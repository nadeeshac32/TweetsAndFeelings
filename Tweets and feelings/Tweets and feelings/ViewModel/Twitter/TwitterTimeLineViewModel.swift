//
//  TwitterTimeLineViewModel.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

struct TwitterTimeLineViewModel {

	weak var dataSource : GenericDataSource<Tweet>?
	
	init(dataSource : GenericDataSource<Tweet>?) {
		self.dataSource = dataSource
	}
	
	var expandCell: ((_ doOpen: Bool, IndexPath) -> Void)?
	var showToast: ((_ alertString: String) -> Void)?
	var pageNumberUpdate: ((_ pageNumber: String) -> Void)?
	
	func swiped(direction: UISwipeGestureRecognizer.Direction, visibleCellIndex: Int) {
		let open = direction == .up ? true : false
		let indexPath = IndexPath(row: visibleCellIndex, section: 0)
		if let dataCount = self.dataSource?.data.value.count, visibleCellIndex < dataCount {
			self.expandCell?(open, indexPath)
			self.dataSource?.cellsIsOpen[indexPath.row] = open
		}
	}
	
	func tapped(visibleCellIndex: Int) {
		if let dataCount = self.dataSource?.data.value.count, dataCount > visibleCellIndex {
			let open = !(self.dataSource?.cellsIsOpen[visibleCellIndex] ?? true)
			let indexPath = IndexPath(row: visibleCellIndex, section: 0)
			if let dataCount = self.dataSource?.data.value.count, indexPath.row < dataCount {
				self.expandCell?(open, indexPath)
				self.dataSource?.cellsIsOpen[visibleCellIndex] = open
			}
		}
	}
	
	func searchWithUsername(username: String?) {
		if let screenNameString = username {
			let trimmed 	= screenNameString.trimmingCharacters(in: CharacterSet.whitespaces)
			if !trimmed.isEqual("") {
				getTweetsForUsernameRequest(username: trimmed)
				return
			}
		} else {
			self.showToast?(AppConfig.si.pleaseFillTheUsernameAlertMsg)
		}
	}
	
	func viewScrolled(visibleCellIndex: Int) {
		if let dataCount = self.dataSource?.data.value.count, dataCount > 0 {
			let pageNumberString = "\(visibleCellIndex + 1)/\(dataCount)"
			self.pageNumberUpdate?(pageNumberString)
		} else {
			self.pageNumberUpdate?("0/0")
		}
	}
	
	private func getTweetsForUsernameRequest(username: String) {
		let httpService = HTTPService()
		httpService.getTweetsForUsername(screenName: username, onSuccess: { (tweets) in
			self.dataSource?.data.value = tweets
		}) { (error) in
			self.dataSource?.data.value = []
			
			let tweeterErrorCodeForNonExistingPage = 34
			switch error {
			case .TwitterError(let errorCode, let errorMsg):
				if errorCode == tweeterErrorCodeForNonExistingPage {
					self.showToast?(errorMsg)
					return
				}
			default:
				break
			}
			self.showToast?(AppConfig.si.somethingWentWrongAlertMsg)
		}
	}
	
	private func getBearerTokenRequest() {
		let httpService = HTTPService()
		httpService.postTweeterBearer(onSuccess: { (token) in
			print("Twitter Bearer Token: \(token.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
	
	private func getSentimentAnylisisForTweetRequest(tweet: Tweet) {
		let httpService = HTTPService()
		httpService.postAnalyseSentiment(analysingString: tweet.text, onSuccess: { (googleSentimentAnylise) in
			print("Google Sentiment Analyse: \(googleSentimentAnylise.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
	
}
