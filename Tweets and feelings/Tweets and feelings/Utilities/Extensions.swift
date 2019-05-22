//
//  Extensions.swift
//  Extensions
//
//  Created by Nadeesha Lakmal on 11/1/17.
//  Copyright © 2017 NadeeshaC32. All rights reserved.
//

import UIKit

public enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor                      = UIColor.black.cgColor
        self.layer.shadowOffset                     = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity                    = 0.2
        self.layer.shadowRadius                     = 1.0
    }
    
    func removeShadow() {
        self.layer.shadowColor                      = UIColor.clear.cgColor
    }
    
    func setConstraintsFor(contentView: UIView, left: Bool = true, top: Bool = true, right: Bool = true, bottom: Bool = true) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        
        var constraints         : [NSLayoutConstraint] = []
        if left {
            let constraintLeft      = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            constraints.append(constraintLeft)
        }
        
        if top {
            let constraintTop       = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            constraints.append(constraintTop)
        }
        
        if right {
            let constraintRight     = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            constraints.append(constraintRight)
        }
        
        if bottom {
            let constraintBottom    = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            constraints.append(constraintBottom)
        }
        
        self.addConstraints(constraints)
    }
    
    func addGradientWithColors(color1: UIColor, color2: UIColor, direction: GradientDirection) {
        let gradient            = CAGradientLayer()
        gradient.frame          = self.bounds
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            gradient.startPoint     = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint       = CGPoint(x: 0.5, y: 1.0)
        }
        
        gradient.colors         = [color1.cgColor, color2.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addBoarder(width: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        self.layer.cornerRadius     = cornerRadius
        self.layer.borderColor      = color.cgColor
        self.layer.borderWidth      = width
        self.clipsToBounds          = true
    }
    
    func removeAllSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func addAsPopupView() {
        self.alpha                  = 0
        UIApplication.shared.keyWindow?.setConstraintsFor(contentView: self)
        UIView.animate(withDuration: 0.25) {
            self.alpha              = 1
        }
    }
    
    func removePopupView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha              = 0
        }) { (completed) in
            self.removeFromSuperview()
            completion?()
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(9999))
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.text = self
        //        label.sizeToFit()
        
        let neededSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        //        print("neededSize.height:   \(neededSize.height)")
        return neededSize.height
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
	
		let reqIndex = index(startIndex, offsetBy: 3)
		return String(self[..<reqIndex])
//        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
		let reqIndex = index(endIndex, offsetBy: -count)
		return String(self[reqIndex...])
//        return substring(to: index(endIndex, offsetBy: -count))
    }
}


extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    func isBetweeenExclusiveRange(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


extension UIImageView {
    func setImageWith(imagePath: String) {
        var image                           = UIImage()
        if let url = URL(string: imagePath), imagePath.range(of:"http") != nil {
            //              print("imageName url:   \(url)")
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("load user image error : \(String(describing: error))")
                }
                
                if let data = data {
                    let imageFromData           = UIImage(data: data)
                    DispatchQueue.main.async(execute: {
                        if imagePath != "" && imageFromData != nil {
                            image               = imageFromData!
                        }
                        self.image              = image
                    })
                }
            }).resume()
        } else {
            print("imageName : error")
        }
    }
}


extension Int {
    func format(f: String) -> String {
//        let someInt = 4, someIntFormat = "03"
//        println("The integer number \(someInt) formatted with \"\(someIntFormat)\" looks like \(someInt.format(someIntFormat))")
//        // The integer number 4 formatted with "03" looks like 004
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
//        let someDouble = 3.14159265359, someDoubleFormat = ".3"
//        println("The floating point number \(someDouble) formatted with \"\(someDoubleFormat)\" looks like \(someDouble.format(someDoubleFormat))")
//        // The floating point number 3.14159265359 formatted with ".3" looks like 3.142
        return String(format: "%\(f)f", self)
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


extension UITableViewCell {
    
    func showSeparator() {
		DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        }
    }
}


extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Dictionary {
	mutating func update(other: Dictionary?) {
		if other != nil {
			for (key,value) in other! {
				self.updateValue(value, forKey:key)
			}
		}
	}
}

//let downGesture                 = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
//    $0.direction                 = .down
//}
//internal func Init<Type>(_ value: Type, block: ((_ object: Type) -> Void)?) -> Type {
//    block?(value)
//    return value
//}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], direction: GradientDirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        
        switch direction {
        case .leftToRight:
            startPoint              = CGPoint(x: 0.0, y: 0.5)
            endPoint                = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            startPoint              = CGPoint(x: 1.0, y: 0.5)
            endPoint                = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            startPoint              = CGPoint(x: 0.5, y: 1.0)
            endPoint                = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            startPoint              = CGPoint(x: 0.5, y: 0.0)
            endPoint                = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor] = [ #colorLiteral(red: 0.768627451, green: 0.8039215686, blue: 0.8352941176, alpha: 1), AppConfig.si.colorPrimary!], direction: GradientDirection) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, direction: direction)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
