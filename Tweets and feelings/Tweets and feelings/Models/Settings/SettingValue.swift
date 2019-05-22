//
//  SettingValue.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class SettingValue: NSObject {
    
    let index           : Int!
    let text            : String!
    let value           : Float!
    
    init(index: Int, text: String, value: Float) {
        self.index      = index
        self.text       = text
        self.value      = value
    }
    
    func getBoolValue() -> Bool {
        if value == 0 {
            return false
        } else {
            return true
        }
    }
    
}
