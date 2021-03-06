//
//  AppDelegate.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import IQKeyboardManager
#if DEBUG
    import GDPerformanceView_Swift
#endif

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // MARK: init keyboard manager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        // MARK: set start controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Storyboards.recipesList
        window?.makeKeyAndVisible()
        // MARK: set navigation bar tint color
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1490196078, green: 0.4745098039, blue: 0.03529411765, alpha: 1)
        // MARK: init perfomance view
        #if DEBUG
            if window != nil {
                GDPerformanceMonitor.sharedInstance.appVersionHidden = true
                GDPerformanceMonitor.sharedInstance.deviceVersionHidden = true
                GDPerformanceMonitor.sharedInstance.startMonitoring()
            }
        #endif
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

}
