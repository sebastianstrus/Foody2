//
//  UITabBarController+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-14.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//
import UIKit

extension UITabBarController {//UIImage
    func createNavController(vc: UIViewController, unselected: String, selected: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(named: unselected)
        navController.tabBarItem.selectedImage = UIImage(named: selected)
        return navController
    }
}
