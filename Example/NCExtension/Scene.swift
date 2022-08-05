//
//  Scene.swift
//  NPSwift_Example
//
//  Created by company on 2021/7/5.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import NCExtension

/// 场景初始化
class Scene: ApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Scene \t didFinishLaunchingWithOptions")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        
        return true // 返回值对外部无影响
    }
    
}
