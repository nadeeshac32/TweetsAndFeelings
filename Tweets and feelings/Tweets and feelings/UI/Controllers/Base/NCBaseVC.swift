//
//  NCBaseVC.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 22/05/2019.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import UIKit

class NCBaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title                                                      = ""
        self.navigationController?.isNavigationBarHidden                = false
        self.navigationController?.navigationBar.isTranslucent          = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage            = UIImage()
        self.navigationController?.view.backgroundColor                 = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 22)!]
    }
    
    override func viewDidLayoutSubviews() {
        view.addGradientWithColors(color1: #colorLiteral(red: 0.768627451, green: 0.8039215686, blue: 0.8352941176, alpha: 1), color2: AppConfig.si.colorPrimary!, direction: GradientDirection.topToBottom)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func customiseView() {
        //  addBackButton()
        //  addEmptyRightButton()
    }
    
    func addBackButton() {
        var customBackButton                                            : UIButton!
        customBackButton                                                = CustomeButtons().getButtonWith()
        customBackButton.addTarget(self, action: #selector(self.backBtnTapped(sender:)), for: UIControl.Event.touchUpInside)
        let leftButton                                                  = UIBarButtonItem(customView: customBackButton)
        self.navigationItem.leftBarButtonItem                           = leftButton
    }
    
    @objc func backBtnTapped(sender: UIButton! = nil) {
        if let _ = self.navigationController?.popViewController(animated: true) {
            
        }
    }
    
    func addEmptyRightButton() {
        let customRightButton                                           = CustomeButtons().getButtonWith(imageName: "")
        let rightButton                                                 = UIBarButtonItem(customView: customRightButton)
        self.navigationItem.rightBarButtonItem                          = rightButton
    }
    
    func removeNavigationBarShadow() {
        self.navigationController?.navigationBar.removeShadow()
    }

}
