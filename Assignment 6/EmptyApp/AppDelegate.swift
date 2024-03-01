//
//  AppDelegate.swift
//  EmptyApp
//
//  Created by rab on 02/15/24.
//  Copyright © 2024 rab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = MainWindow(frame: UIScreen.main.bounds)
        if let window = window as? MainWindow {
            window.backgroundColor = UIColor.lightGray
            let rootViewController = UIViewController()
            rootViewController.view = window.mainView
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}
