//
//  AppDelegate.swift
//  HappydayCountdown
//
//  Created by Wei Jen Wang on 2022/9/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Utilities.shared.computeAllDayData()
    }
}

