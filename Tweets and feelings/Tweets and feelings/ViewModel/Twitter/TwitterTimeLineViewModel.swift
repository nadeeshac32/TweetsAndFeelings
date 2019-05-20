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
		if let dataCount = self.dataSource?.data.value.count, indexPath.row < dataCount {
			self.expandCell?(open, indexPath)
			self.dataSource?.cellsIsOpen[indexPath.row] = open
		}
	}
	
	func searchWithUsername(username: String) {
		getTweetsForUsernameRequest(username: username)
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
	
}
