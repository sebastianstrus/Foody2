//
//  AppFonts.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-28.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

struct AppFonts {
    static let TITLE_FONT = UIFont(name: "LuckiestGuy-Regular", size: Device.IS_IPHONE ? 90 : 180)
    static let SUBTITLE_FONT = UIFont(name: "Oswald-Medium", size: Device.IS_IPHONE ? 40 : 80)
    static let BTN_FONT = UIFont(name: "SeymourOne", size: Device.IS_IPHONE ? 26 : 52)
    static let NAV_BAR_FONT = UIFont(name: "Georgia-Bold", size: Device.IS_IPHONE ? 24 : 40)
    static let LIST_CELL_FONT = UIFont.boldSystemFont(ofSize: Device.IS_IPHONE ? 26 : 52)
}
