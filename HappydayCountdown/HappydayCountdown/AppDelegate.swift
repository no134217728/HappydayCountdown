//
//  AppDelegate.swift
//  HappydayCountdown
//
//  Created by Wei Jen Wang on 2022/9/12.
//

import UIKit
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Utilities.shared.computeAllDayData()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

