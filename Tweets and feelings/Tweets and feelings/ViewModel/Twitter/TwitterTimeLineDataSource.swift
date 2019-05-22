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

class TwitterTimeLineDataSource: GenericDataSource<Tweet>, UICollectionViewDataSource {
	
	func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		return data.value.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellObj					=  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TweetCollectionViewCell.self), for: indexPath)
		
		guard let cell 				= cellObj as? TweetCollectionViewCell else { return UICollectionViewCell() }
		let index 					= indexPath.row % data.value.count
		let tweet 					= data.value[index]
		cell.viewModel?.tweet 		= tweet
		cell.cellIsOpen(cellsIsOpen[index], animated: false)
		
		return cell
	}
}
