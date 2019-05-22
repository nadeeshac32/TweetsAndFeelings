//
//  SettingsVC.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class SettingsVC: NCBaseVC {

    @IBOutlet weak var tableVw: UITableView!
    
    let settingDataSource                               = SettingDataSource()
    
    lazy var viewModel                                  = SettingsViewModel(dataSource: settingDataSource)
    
    override func customiseView() {
        super.customiseView()
        
        tableVw.tableFooterView                         = UIView(frame: CGRect.zero)
        tableVw.bounces                                 = false
        tableVw.backgroundColor                         = UIColor.clear
        tableVw.separatorStyle                          = .none
        tableVw.estimatedRowHeight                      = 60
        tableVw.register(UINib(nibName: "SettingWithSwitchTVCell", bundle: nil), forCellReuseIdentifier: "SettingWithSwitchTVCell")
        tableVw.register(UINib(nibName: "SettingWithDropDownTVCell", bundle: nil), forCellReuseIdentifier: "SettingWithDropDownTVCell")
        
        tableVw.dataSource                              = settingDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title                                      = "Settings"
    }
    
}
