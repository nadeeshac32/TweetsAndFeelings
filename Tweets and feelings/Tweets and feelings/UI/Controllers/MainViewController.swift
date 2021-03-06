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
	
	@IBOutlet weak var searchTxtFld	    : UITextField!
	@IBOutlet weak var searchBtn	    : UIButton!
    @IBOutlet weak var settingBtn       : UIButton!
    @IBOutlet var pageLabel			    : UILabel!
	
	let twitterTimelinedataSource       = TwitterTimeLineDataSource()
	
	lazy var viewModel: TwitterTimeLineViewModel = {
		var viewModel                   = TwitterTimeLineViewModel(dataSource: twitterTimelinedataSource)
		
		viewModel.expandCell 			= { [weak self] (doOpen: Bool, indexPath: IndexPath) in
			guard let cell              = self?.collectionView?.cellForItem(at: indexPath) as? TweetCollectionViewCell else { return }
			cell.cellIsOpen(doOpen)
			self?.view.endEditing(true)
		}
		
		viewModel.showToast 			= { [weak self] (alertString: String) in
			self?.view.makeToast(alertString)
			self?.view.endEditing(true)
		}
		
		viewModel.pageNumberUpdate 		= { [weak self] (pageNumber: String) in
			self?.pageLabel.text        = pageNumber
		}
		
		viewModel.sentimentAnalised 	= { [weak self] (sentiment: Sentiment, indexPath: IndexPath) in
			guard let cell              = self?.collectionView?.cellForItem(at: indexPath) as? TweetCollectionViewCell else { return }
			cell.viewModel?.sentiment   = sentiment
		}
		
		viewModel.reloardDataAccordingToDataSource = { [weak self] in
            self?.collectionView?.reloadData()
            self?.viewModel.viewScrolled(visibleCellIndex: self?.currentIndex ?? 0)
			self?.view.endEditing(true)
        }
        
		return viewModel
	}()
	
	override func viewDidLoad() {
		itemSize                        = CGSize(width: 240, height: 460)
		super.viewDidLoad()
		
        view.addGradientWithColors(color1: #colorLiteral(red: 0.7690889239, green: 0.8050159812, blue: 0.8344388008, alpha: 1), color2: AppConfig.si.colorPrimary!, direction: GradientDirection.topToBottom)
        settingBtn.setImage(UIImage(named: "settingIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
		pageLabel.layer.cornerRadius 	= 5
		searchBtn.layer.cornerRadius 	= 5
		
		let nib                         = UINib(nibName: String(describing: TweetCollectionViewCell.self), bundle: nil)
		collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: TweetCollectionViewCell.self))
		
		let upGesture 	            	= UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))
		upGesture.direction             = .up
		
		let downGesture 	            = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))
		downGesture.direction           = .down
		
		let tapGesture 		            = UITapGestureRecognizer(target: self, action: #selector(MainViewController.tapHandler(_:)))
		
		collectionView?.addGestureRecognizer(upGesture)
		collectionView?.addGestureRecognizer(downGesture)
		collectionView?.addGestureRecognizer(tapGesture)
		
        self.collectionView?.dataSource 								= self.twitterTimelinedataSource
        self.collectionView?.backgroundView?.backgroundColor 			= .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title                                                      = ""
        self.navigationController?.isNavigationBarHidden                = true
        self.navigationController?.navigationBar.isTranslucent          = true
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		super.touchesBegan(touches, with: event)
	}
	
	
	@objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
		self.viewModel.swiped(direction: sender.direction, visibleCellIndex: self.currentIndex)
	}
	
	@objc func tapHandler(_ sender: UITapGestureRecognizer) {
		self.viewModel.tapped(visibleCellIndex: self.currentIndex)
	}
	
	func scrollViewDidScroll(_: UIScrollView) {
		self.viewModel.viewScrolled(visibleCellIndex: self.currentIndex)
	}
	
	@IBAction func searchBtnTapped(_ sender: UIButton) {
		self.viewModel.searchWithUsername(username: searchTxtFld.text)
	}
	
}
