//
//  Double+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-28.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation


extension Double {
    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var decimalValue = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, scale, mode)
        return result
    }
}
