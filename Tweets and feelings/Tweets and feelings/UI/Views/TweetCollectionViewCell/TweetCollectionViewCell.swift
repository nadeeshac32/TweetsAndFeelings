//
//  TweetCollectionViewCell.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import expanding_collection

class TweetCollectionViewCell: BasePageCollectionCell {

	@IBOutlet weak var userImageVw              : UIImageView!
	@IBOutlet weak var fronContainerBgImageVw   : UIImageView!
	@IBOutlet weak var frontContainerOpasityVw  : UIView!
	@IBOutlet weak var userNameLbl              : UILabel!
	@IBOutlet weak var userScreenNameLbl        : UILabel!
	@IBOutlet weak var tweetContentLbl          : UILabel!
	@IBOutlet weak var sentimentAnalyseLbl      : UILabel!
	@IBOutlet weak var scoreLbl                 : UILabel!
	@IBOutlet weak var magnitudeLbl             : UILabel!
	
	var viewModel 					            : TweetViewModel? {
		didSet {
			self.viewModel?.setBasicDetails = { [weak self] (username: String, screenName: String, content: String, userImaeUrl: String) in
				self?.userNameLbl.text 			= username
				self?.userScreenNameLbl.text 	= screenName
				self?.tweetContentLbl.text 		= content
				self?.userImageVw.setImageWith(imagePath: userImaeUrl)
			}
			
			self.viewModel?.setSentimentDetails = { [weak self] (score: String, magniture: String, feeling: String) in
				self?.sentimentAnalyseLbl.text 	= feeling
				self?.scoreLbl.text 			= score
				self?.magnitudeLbl.text 		= magniture
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        frontContainerOpasityVw.layer.cornerRadius 	= 5
		userNameLbl.text 			            = ""
		userScreenNameLbl.text 		            = ""
		tweetContentLbl.text 		            = ""
		sentimentAnalyseLbl.text 	            = ""
		scoreLbl.text 			            	= ""
		magnitudeLbl.text 			            = ""
		userImageVw.addBoarder(width: 3, cornerRadius: userImageVw.frame.size.width / 2, color: .white)
		
		viewModel 					            = TweetViewModel()
    }
	
}
