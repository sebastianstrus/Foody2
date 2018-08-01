//
//  String+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-17.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

extension String {
    
    // use:     myLabel.text = "Hi".localized()
    //          myLabel.text = "Hi".localized(withComment: "with !!!")
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    // use:     myLabel.text = "Hi".localized
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
