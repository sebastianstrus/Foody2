//
//  UITextField+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

extension UITextField {
    
    public convenience init(placeHolder: String) {
        self.init()
        self.borderStyle = .none
        self.layer.cornerRadius = Device.IS_IPHONE ? 5 : 10
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2)
        self.textColor = UIColor(white: 0.9, alpha: 0.8)
        self.font = UIFont.systemFont(ofSize: Device.IS_IPHONE ? 17 : 34)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        // placeholder
        var placeholder = NSMutableAttributedString()
        placeholder = NSMutableAttributedString(attributedString: NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: Device.IS_IPHONE ? 18 : 36), .foregroundColor: UIColor(white: 1, alpha: 0.7)]))
        self.attributedPlaceholder = placeholder
        // anchor
        self.setAnchor(width: 0, height: Device.IS_IPHONE ? 40 : 80)
        self.setLeftPaddiingPoints(Device.IS_IPHONE ? 20 : 40)
    }
    
    func setLeftPaddiingPoints(_ space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func showWarning() {
        let warningView = UIImageView(frame: CGRect(x: 0, y: 0, width: Device.IS_IPHONE ? 40 : 80, height: Device.IS_IPHONE ? 30 : 60))
        warningView.image = UIImage(named: "warning_icon")
        warningView.contentMode = .scaleAspectFit
        self.rightViewMode = .always
        self.rightView = warningView
        //warningView.setAnchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 30, height: 0)
    }
    
    func hideWarning() {
        self.rightViewMode = .never
        self.rightView = nil
    }
}
