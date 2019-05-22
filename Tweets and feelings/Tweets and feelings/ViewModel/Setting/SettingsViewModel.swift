//
//  SettingsViewModel.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject {
    
    weak var dataSource                     : GenericDataSource<Setting>?
    
    init(dataSource: GenericDataSource<Setting>?) {
        self.dataSource                     = dataSource
    }

}
