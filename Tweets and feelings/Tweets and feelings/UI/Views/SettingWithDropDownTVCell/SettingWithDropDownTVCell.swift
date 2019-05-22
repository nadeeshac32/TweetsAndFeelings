//
//  SettingWithDropDownTVCell.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import DropDown

class SettingWithDropDownTVCell: UITableViewCell {

    @IBOutlet weak var innerView                        : UIView!
    @IBOutlet weak var titleLbl                         : UILabel!
    @IBOutlet weak var descLbl                          : UILabel!
    
    let settingOptions: DropDown                        = DropDown()
    
    var viewModel: SettingViewModel? {
        didSet {
            self.viewModel?.setBasicDetails = { [weak self] (title: String, desc: String, value: SettingValue?) in
                self?.titleLbl.text                     = title
                self?.descLbl.text                      = desc
                self?.descLbl.text                      = value?.text ?? ""
            }
            
            self.viewModel?.setDropDownDetails = { [weak self] (dataSource: [String], selectedValueIndex: Int?) in
                self?.settingOptions.dataSource         = dataSource
                self?.settingOptions.anchorView         = self?.descLbl
                self?.settingOptions.width              = self?.descLbl.frame.width
                self?.settingOptions.cellHeight         = 35
                self?.settingOptions.direction          = .bottom
                self?.settingOptions.bottomOffset       = CGPoint(x: 0,
                                                                  y: (self?.settingOptions.anchorView?.plainView.bounds.height)!)
                
                self?.settingOptions.selectionAction    = { [weak self] (index: Int, item: String) in
                    self?.descLbl.text                  = item
                    self?.viewModel?.setValueWithIndex(index: index)
                }
                if let index = selectedValueIndex {
                    self?.settingOptions.selectRow(index)
                }
            }
            
            self.viewModel?.showDropDown = { [weak self] in
                self?.settingOptions.show()
            }
        }
    }
    
    override func awakeFromNib() {
        let selfTapGes                                  = UITapGestureRecognizer(target: self, action: #selector(SettingWithDropDownTVCell.handleSelfTapGes))
        self.innerView.addGestureRecognizer(selfTapGes)
        self.titleLbl.text                              = ""
        self.descLbl.text                               = ""
        
        self.viewModel                                  = SettingViewModel()
    }
    
    
    @objc func handleSelfTapGes(sender: UITapGestureRecognizer) {
        self.viewModel?.selfTapped()
    }

}
