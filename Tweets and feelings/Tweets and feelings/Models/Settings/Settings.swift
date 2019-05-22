//
//  Settings.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    static let si                       = Settings()
    
    var tweetCount                      : Setting?
    var sampleToggleSetting             : Setting?
    
    var settingsArray                   : [Setting] = []
    
    private override init() {
        
        var valuesTweetCount  : [SettingValue] = []
        valuesTweetCount.append(SettingValue(index: 0, text: "Get 5 tweets", value: 5))
        valuesTweetCount.append(SettingValue(index: 1, text: "Get 10 tweets", value: 10))
        valuesTweetCount.append(SettingValue(index: 2, text: "Get 10 tweets", value: 15))
        tweetCount                      = Setting(keyWord: "tweetCount",
                                                  type: SettingType.general,
                                                  title: "Tweet count",
                                                  desc: "Select how many tweets you want to get",
                                                  valueSelectionOption: SettingsValueSelectionOption.dropDown,
                                                  values: valuesTweetCount,
                                                  defaultValueIndex: 0)
        settingsArray.append(tweetCount!)
        
        var valuesSampleToggleSetting   : [SettingValue] = []
        valuesSampleToggleSetting.append(SettingValue(index: 0, text: "Desable", value: 0))
        valuesSampleToggleSetting.append(SettingValue(index: 1, text: "Enable", value: 1))
        sampleToggleSetting             = Setting(keyWord: "sampleToggleSetting",
                                                  type: .general,
                                                  title: "Sample toggle setting",
                                                  desc: "By enabling or desabling, you can access a Boolean setting",
                                                  valueSelectionOption: SettingsValueSelectionOption.toggle,
                                                  values: valuesSampleToggleSetting,
                                                  defaultValueIndex: 0,
                                                  action: { (settingValue) in
                                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                    appDelegate.showAlert(title: "You set Boolean value '\(String(describing: settingValue?.getBoolValue() ?? false))' for Sample Toggle Setting")
                                                  })
        settingsArray.append(sampleToggleSetting!)
    }
    
    func removeSavedSettings() {
        for setting in settingsArray {
            setting.resetSetting()
        }
    }
    
    func getSettingTypes() -> [SettingType] {
        var settingTypes                : [SettingType] = []
        for setting in settingsArray {
            if !(settingTypes.contains(setting.type)) {
                settingTypes.append(setting.type)
            }
        }
        return settingTypes
    }
    
    func getSettingsFor(settingType: SettingType) -> [Setting] {
        var settings                : [Setting] = []
        for setting in settingsArray {
            if setting.type == settingType {
                settings.append(setting)
            }
        }
        return settings
    }
    
}



