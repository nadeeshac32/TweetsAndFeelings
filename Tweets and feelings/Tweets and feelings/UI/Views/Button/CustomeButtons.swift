//
//  CustomeButtons.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit
class CustomeButtons {
    func getButtonWith(imageName: String = "ios_arrow_left_icon") -> UIButton {
        let button                                      = UIButton(type: .custom)
        button.frame                                    = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.clipsToBounds                            = true
        button.backgroundColor                          = UIColor.clear
        button.contentVerticalAlignment                 = .center
        let buttonImage                                 = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor                                = UIColor.white
        button.heightAnchor.constraint(equalToConstant: 40)
        button.widthAnchor.constraint(equalToConstant: 40)
        return button
    }
    
    func getButtonWith(text: String, width: CGFloat? = 120) -> UIButton {
        let button                                      = UIButton(type: .custom)
        button.frame                                    = CGRect(x: 0, y: 0, width: width!, height: 44)
        button.clipsToBounds                            = true
        button.backgroundColor                          = UIColor.clear
        button.contentVerticalAlignment                 = .center
        button.setTitle(text, for: .normal)
        button.titleLabel?.font                         = UIFont.systemFont(ofSize: 12)
        return button
    }
    
    func getSwitch() -> UISwitch {
        let switchTemp                                  = UISwitch(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        switchTemp.onTintColor                          = UIColor(hexString: "000000")?.withAlphaComponent(0.3)
        switchTemp.setOn(false, animated: false)
        return switchTemp
    }
}
