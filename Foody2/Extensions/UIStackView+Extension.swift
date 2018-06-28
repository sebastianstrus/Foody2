//
//  UIStackView+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
