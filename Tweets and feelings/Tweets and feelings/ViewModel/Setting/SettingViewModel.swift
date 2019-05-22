//
//  SettingViewModel.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

struct SettingViewModel {
    
    var setting: Setting? {
        didSet {
            self.setBasicDetails?(setting?.title ?? "", setting?.desc ?? "", setting?.selectedValue)
            self.setDropDownDetails?(setting?.values.map { $0.text } ?? [], setting?.selectedValue?.index)
        }
    }
    
    init() {}

    var setBasicDetails: ((String, String, SettingValue?) -> Void)?             //     title, desc, isOn
    
    var setDropDownDetails: (([String], Int?) -> Void)?                            // dataSource, selectedValueIndex
    
    var showDropDown: (() -> Void)?
    
    func setValueWithBool(booleanValue: Bool) {
        self.setting?.saveSettingValueWithBool(boolValue: booleanValue)
    }
    
    func setValueWithIndex(index: Int) {
        self.setting?.saveSettingValueIndex(index: index)
    }
    
    func selfTapped() {
        self.showDropDown?()
    }
}
