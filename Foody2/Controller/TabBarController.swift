//
//  TabBarController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    // TODO: add images with two colors
    func setupTabBar() {
        tabBar.barTintColor = AppColors.SILVER_GREY
        tabBar.tintColor = AppColors.MAIN_PURPLE

        let listController = createNavController(vc: ListController(), unselected: "list_unselected", selected: "list_selected")
        listController.tabBarItem.title = "List".localized
        let addMealController = createNavController(vc: AddMealControler(), unselected: "add_unselected", selected: "add_selected")
        addMealController.tabBarItem.title = "Add".localized
        let mapController = createNavController(vc: MapController(), unselected: "map_unselected", selected: "map_selected")
        mapController.tabBarItem.title = "Map".localized
        let favoritesController = createNavController(vc: FavoritesController(), unselected: "favorites_unselected", selected: "favorites_selected")
        favoritesController.tabBarItem.title = "Favorites".localized
        let accountController = createNavController(vc: AccountController(), unselected: "account_unselected", selected: "account_selected")
        accountController.tabBarItem.title = "Account".localized

        //list, add, map, favorite, account
        viewControllers = [listController, addMealController, mapController, favoritesController, accountController]
        
        //set top margin
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
