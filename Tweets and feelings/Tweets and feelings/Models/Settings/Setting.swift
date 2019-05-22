//
//  Setting.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

public enum SettingType: String {
    case general    = "General"
    
    func getIconImgName() -> String {
        switch self {
        case .general:
            return "info_icon"
        }
    }
}

public enum SettingsValueSelectionOption: String {
    case toggle     = "Toggle"
    case dropDown   = "DropDown"
}

class Setting: NSObject {
    let defaults                    = UserDefaults.standard
    
    var keyWord                     : String!
    var type                        : SettingType!
    var title                       : String!
    var desc                        : String!
    var valueSelectionOption        : SettingsValueSelectionOption!
    var values                      : [SettingValue]!
    var selectedValue               : SettingValue? {
        didSet {
            if valueSelectionOption == SettingsValueSelectionOption.dropDown {
                self.desc           = selectedValue?.text ?? ""
            }
            self.action?(selectedValue)
        }
    }
    var defaultValueIndex           : Int!
    var action                      : ((_ settingValue: SettingValue?) -> Void)?
    
    init(keyWord: String, type: SettingType, title: String, desc: String, valueSelectionOption: SettingsValueSelectionOption, values: [SettingValue], defaultValueIndex: Int, action: ((_ settingValue: SettingValue?) -> Void)? = nil) {
        super.init()
        self.keyWord                = keyWord
        self.type                   = type
        self.title                  = title
        self.desc                   = desc
        self.valueSelectionOption   = valueSelectionOption
        self.values                 = values
        self.defaultValueIndex      = defaultValueIndex
        self.readSetting(keyWord: keyWord, defaultValueIndex: defaultValueIndex)
        self.action                 = action
    }
    
    internal func readSetting(keyWord: String, defaultValueIndex: Int) {
        var savedSettingIndexForKeyword: Int!
        if defaults.object(forKey: keyWord) != nil {
            savedSettingIndexForKeyword = defaults.integer(forKey: keyWord)
        } else {
            savedSettingIndexForKeyword = defaultValueIndex
        }
        
        if savedSettingIndexForKeyword >= 0, savedSettingIndexForKeyword < values.count {
            self.selectedValue      = values[savedSettingIndexForKeyword]
        }
    }
    
    func saveSettingValueIndex(index: Int) {
        defaults.set(index, forKey: self.keyWord)
        if index >= 0, index < values.count {
            self.selectedValue      = values[index]
        }
    }
    
    func saveSettingValueWithBool(boolValue: Bool) {
        let index                   = boolValue ? 1 : 0
        defaults.set(index, forKey: self.keyWord)
        if index >= 0, index < values.count {
            self.selectedValue      = values[index]
        }
    }
    
    func resetSetting() {
        saveSettingValueIndex(index: defaultValueIndex)
    }
}
