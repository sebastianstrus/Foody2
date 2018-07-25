//
//  Date+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-22.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation

extension Date {
    func formatedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
