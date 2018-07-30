//
//  AppDelegate.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-03.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase
import KVNProgress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var basicConfiguration: KVNProgressConfiguration?
    
    // MARK: - UIApplication functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        //create main window without storyboard
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let tabBarVC = TabBarController()
        window?.rootViewController = tabBarVC
        
        presetProgressHUD()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Helpers
    func presetProgressHUD() {
        basicConfiguration = KVNProgressConfiguration.default()
        basicConfiguration?.isFullScreen = true
        basicConfiguration?.backgroundType = KVNProgressBackgroundType.blurred
        basicConfiguration?.statusFont = UIFont(name: "HelveticaNeue", size: 24.0)
        basicConfiguration?.minimumSuccessDisplayTime = 0.5
        KVNProgress.setConfiguration(self.basicConfiguration)
        
        //! workaround to solve problem with displaying "frosted glass" for the full screen messages
        KVNProgress.show(0.0, status: "Loading", on: nil)
        KVNProgress.dismiss()
    }
}
