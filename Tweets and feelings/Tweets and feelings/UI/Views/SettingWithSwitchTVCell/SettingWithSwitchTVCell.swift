//
//  SettingWithSwitchTVCell.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class SettingWithSwitchTVCell: UITableViewCell {
    @IBOutlet weak var titleLbl         : UILabel!
    @IBOutlet weak var descLbl          : UILabel!
    @IBOutlet weak var enableSwitch     : UISwitch!
    
    var viewModel                       : SettingViewModel? {
        didSet {
            self.viewModel?.setBasicDetails = { [weak self] (title: String, desc: String, value: SettingValue?) in
                self?.titleLbl.text     = title
                self?.descLbl.text      = desc
                self?.enableSwitch.isOn = value?.getBoolValue() ?? false
            }
        }
    }
    
    override func awakeFromNib() {
        self.titleLbl.text              = ""
        self.descLbl.text               = ""
        self.enableSwitch.isOn          = false
        
        self.viewModel                  = SettingViewModel()
    }
    
    @IBAction func enableSwitchValueChanged(_ sender: UISwitch) {
        viewModel?.setValueWithBool(booleanValue: sender.isOn)
    }
    
}
