//
//  SettingDataSource.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class SettingDataSource: GenericDataSource<Setting>, UITableViewDataSource, UITableViewDelegate {
    
    override init() {
        super.init()
        data.value                                      = Settings.si.getSettingsFor(settingType: .general)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting                                     = data.value[indexPath.row]
        
        var cell                                        = UITableViewCell()
        if setting.valueSelectionOption == SettingsValueSelectionOption.toggle {
            let settingCell                             = tableView.dequeueReusableCell(withIdentifier: "SettingWithSwitchTVCell", for: indexPath) as! SettingWithSwitchTVCell
            settingCell.viewModel?.setting              = setting
            cell                                        = settingCell
        } else if setting.valueSelectionOption == SettingsValueSelectionOption.dropDown {
            let settingCell                             = tableView.dequeueReusableCell(withIdentifier: "SettingWithDropDownTVCell", for: indexPath) as! SettingWithDropDownTVCell
            settingCell.viewModel?.setting              = setting
            cell                                        = settingCell
        }
        cell.selectionStyle                             = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let setting                                     = data.value[indexPath.row]
        if setting.valueSelectionOption == SettingsValueSelectionOption.toggle {
            return 90
        } else {
            return 70
        }
    }
    
}
