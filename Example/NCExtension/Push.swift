//
//  Push.swift
//  NPSwift_Example
//
//  Created by beantechs on 2021/12/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import NCExtension

/// 场景初始化
class Push: ApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Push \t didFinishLaunchingWithOptions")
        return true // 返回值对外部无影响
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Push \t applicationDidBecomeActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Push \t applicationDidEnterBackground")
    }
}
