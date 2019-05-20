//
//  TwitterTimeLineDataSource.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

class TwitterTimeLineDataSource : GenericDataSource<Tweet>, UICollectionViewDataSource {
	
	func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		return data.value.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellObj					=  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TweetCollectionViewCell.self), for: indexPath)
		
		guard let cell 				= cellObj as? TweetCollectionViewCell else { return UICollectionViewCell() }
		let index 					= indexPath.row % data.value.count
		let tweet 					= data.value[index]
		cell.userNameLbl.text 		= tweet.user?.name
		cell.userScreenNameLbl.text = "@\(tweet.user?.screen_name ?? "")"
		cell.tweetContentLbl.text 	= tweet.text
		cell.cellIsOpen(cellsIsOpen[index], animated: false)
		
		return cell
	}
	
	
	
//	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
//		guard let cell = cell as? TweetCollectionViewCell else { return }
//
//		let index = indexPath.row % data.value.count
//		let tweet = data.value[index]
//		cell.userNameLbl.text = tweet.user?.name
//		cell.userScreenNameLbl.text = "@\(tweet.user?.screen_name ?? "")"
//		cell.tweetContentLbl.text 	= tweet.text
//		cell.cellIsOpen(cellsIsOpen[index], animated: false)
//	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("didSelectItemAt indexPath: IndexPath : \(indexPath.row)")
		guard let cell = collectionView.cellForItem(at: indexPath) as? TweetCollectionViewCell else { return }	//	, self.currentIndex == indexPath.row
		if cell.isOpened == false {
			cell.cellIsOpen(true)
		} else {
			cell.cellIsOpen(false)
		}
	}
	
	
	
	
	
//	func numberOfSections(in tableView: UITableView) -> Int {
//		return 1
//	}
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return data.value.count
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//		let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
//
//		let currencyRate = self.data.value[indexPath.row]
//		cell.currencyRate = currencyRate
//
//		return cell
//	}
}
