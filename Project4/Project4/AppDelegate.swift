//
//  AppDelegate.swift
//  Project4
//
//  Created by 野中淳 on 2022/11/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let navigatiorController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigatiorController
        
        return true
        
    }


}

