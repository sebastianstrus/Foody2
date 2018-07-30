//
//  Constants.swift
//  ISMP
//
//  Created by Sebastian Strus on 2018-06-14.
//  Copyright © 2018 OpenSolution. All rights reserved.
//

import UIKit

let RESIZE = UIScreen.main.bounds.size.height / 667

struct Device {
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}

// Constants for keys
struct AppKeys {
}

// Constants for URL
struct AppLayoutParams {
    static let TABBAR_HEIGHT = Int(UITabBarController().tabBar.frame.size.height)
}

// Constants for URL
struct AppURLs {
    static let HOME_PAGE = "http://sebastianstrus.github.io"
    static let FOODY_DB = "https://foody-4454f.firebaseio.com/"
}
