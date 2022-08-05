//
//  ViewController.swift
//  NPSwift
//
//  Created by Kalanhall@163.com on 12/22/2021.
//  Copyright (c) 2021 Kalanhall@163.com. All rights reserved.
//

import UIKit
import NCExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let btn = UIButton().nc.with {
            $0.frame = CGRect(x: 0, y: 100, width: 60, height: 60)
            $0.layer.borderWidth = 2
        }
        view.addSubview(btn)
        
        btn.nc.subscribe(.touchUpInside) { [weak self] _ in
            self?.present(ViewController2(), animated: true, completion: nil)
        }
    
    }

}

class Person: NSObject {
    @objc dynamic var name: String = ""
}


class ViewController2: UIViewController {
    
    let person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        self.nc.observe(for: "1".nc.notification, object: nil) { notification in
            print("来了通知")
        }
        
        self.nc.observe(person, for: #keyPath(Person.name), options: [.new]) { obj, change in
            print("来了KVO")
        }
        
        // 触发KVO
        self.person.name = "Test"
        // 触发通知
        NotificationCenter.default.post(name: "1".nc.notification, object: nil)
        
        self.nc.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("timer run1.")
        }
        
//        self.nc.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            print("timer run2.")
//        }
//
//        NPReachability.nc.subscribe { reachability in
//            print("network = \(reachability.status)")
//
//            NPReachability.nc.cancleSubscribe()
//        }
//
//        self.nc.observe(for: UIApplication.didBecomeActiveNotification, object: nil) { _ in
//            print("\(self.classForCoder) \t didBecomeActiveNotification")
//        }
//
//        self.nc.observe(for: UIApplication.didEnterBackgroundNotification, object: nil) { _ in
//            print("\(self.classForCoder) \t didEnterBackgroundNotification")
//        }
    }
}
