//
//  AppDelegate.swift
//  NPSwift
//
//  Created by Kalanhall@163.com on 12/22/2021.
//  Copyright (c) 2021 Kalanhall@163.com. All rights reserved.
//

import UIKit
import NCExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let 🚀 = NCLaunchQueue([
        // first launch
        Scene(),
        // second launch
        Push()
    ])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        🚀.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        🚀.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        🚀.applicationDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        🚀.applicationDidEnterBackground(application)
    }

}
