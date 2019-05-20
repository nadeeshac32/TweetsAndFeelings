//
//  MainViewController.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import expanding_collection
import Toast_Swift

class MainViewController: ExpandingViewController {
	
	@IBOutlet weak var searchTxtFld: UITextField!
	@IBOutlet weak var searchBtn: UIButton!
	@IBOutlet var pageLabel: UILabel!
	
	let twitterTimelinedataSource = TwitterTimeLineDataSource()
	
	lazy var viewModel : TwitterTimeLineViewModel = {
		var viewModel = TwitterTimeLineViewModel(dataSource: twitterTimelinedataSource)
		
		viewModel.expandCell = { (doOpen: Bool, indexPath: IndexPath) in
			guard let cell = self.collectionView?.cellForItem(at: indexPath) as? TweetCollectionViewCell else { return }
			cell.cellIsOpen(doOpen)
		}
		viewModel.showToast = { (alertString: String) in
			self.view.makeToast(alertString)
		}
		viewModel.pageNumberUpdate = { [weak self] (pageNumber: String) in
			self?.pageLabel.text = pageNumber
		}
		
		return viewModel
	}()
	
	override func viewDidLoad() {
		itemSize = CGSize(width: 240, height: 460)
		super.viewDidLoad()
		
		view.addGradientWithColors(color1: #colorLiteral(red: 0.7690889239, green: 0.8050159812, blue: 0.8344388008, alpha: 1), color2: AppConfig.si.colorPrimary!, direction: GradientDirection.topToBottom)
		pageLabel.layer.cornerRadius 	= 5
		searchBtn.layer.cornerRadius 	= 5
		
		registerCell()
		addGesture(to: collectionView!)
		
		self.collectionView?.dataSource = self.twitterTimelinedataSource
		
		self.twitterTimelinedataSource.data.addAndNotify(observer: self) { [weak self] in
			self?.twitterTimelinedataSource.cellsIsOpen = Array(repeating: false, count: self?.twitterTimelinedataSource.data.value.count ?? 0)
			self?.collectionView?.reloadData()
			self?.viewModel.viewScrolled(visibleCellIndex: self?.currentIndex ?? 0)
		}
    }
	
	fileprivate func registerCell() {
		let nib = UINib(nibName: String(describing: TweetCollectionViewCell.self), bundle: nil)
		collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: TweetCollectionViewCell.self))
	}
	
	fileprivate func addGesture(to view: UIView) {
		let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
			$0.direction = .up
		}
		
		let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
			$0.direction = .down
		}
		view.addGestureRecognizer(upGesture)
		view.addGestureRecognizer(downGesture)
	}
	
	internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
		block(value)
		return value
	}
	
	@objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
		self.viewModel.swiped(direction: sender.direction, visibleCellIndex: self.currentIndex)
	}
	
	func scrollViewDidScroll(_: UIScrollView) {
		self.viewModel.viewScrolled(visibleCellIndex: self.currentIndex)
	}
	
	@IBAction func searchBtnTapped(_ sender: UIButton) {
		if let screenNameString = searchTxtFld.text {
			let trimmed = screenNameString.trimmingCharacters(in: CharacterSet.whitespaces)
			if !trimmed.isEqual("") {
				self.viewModel.searchWithUsername(username: trimmed)
			}
		}
	}
	
}


// MARK: UICollectionViewDataSource
//extension MainViewController {
//
//	override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
//		return items.count
//	}
//
//	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TweetCollectionViewCell.self), for: indexPath)
//	}
//
//	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
//		guard let cell = cell as? TweetCollectionViewCell else { return }
//
//		let index = indexPath.row % items.count
//		let tweet = items[index]
//		cell.userNameLbl.text = tweet.user?.name
//		cell.userScreenNameLbl.text = "@\(tweet.user?.screen_name ?? "")"
//		cell.tweetContentLbl.text 	= tweet.text
//		cell.cellIsOpen(cellsIsOpen[index], animated: false)
//	}
//
//	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		guard let cell = collectionView.cellForItem(at: indexPath) as? TweetCollectionViewCell
//			, currentIndex == indexPath.row else { return }
//
//		if cell.isOpened == false {
//			cell.cellIsOpen(true)
//		} else {
//			cell.cellIsOpen(false)
//		}
//	}
//}


extension MainViewController {
	func getBearerTokenRequest() {
		let httpService = HTTPService()
		httpService.postTweeterBearer(onSuccess: { (token) in
			print("Twitter Bearer Token: \(token.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
	
//	func getTweetsForUsernameRequest(username: String) {
//		let httpService = HTTPService()
//		httpService.getTweetsForUsername(screenName: username, onSuccess: { (tweets) in
//			self.items = tweets
//			self.fillCellIsOpenArray()
//		}) { (error) in
//			print("Rest Client Error: \(error)")
//		}
//	}
	
	func getSentimentAnylisisForTweetRequest(tweet: Tweet) {
		let httpService = HTTPService()
		httpService.postAnalyseSentiment(analysingString: tweet.text, onSuccess: { (googleSentimentAnylise) in
			print("Google Sentiment Analyse: \(googleSentimentAnylise.toJSON())")
		}) { (error) in
			print("Rest Client Error: \(error)")
		}
	}
}
