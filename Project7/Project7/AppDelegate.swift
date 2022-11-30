//
//  AppDelegate.swift
//  Project7
//
//  Created by 野中淳 on 2022/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground

        
        let tabBarControlloer = UITabBarController()

        let firstViewController = ViewController()
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        
        let secondViewController = ViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        let secondNavController = UINavigationController(rootViewController: secondViewController)

        
        tabBarControlloer.viewControllers = [firstNavController,secondNavController]
        
        window?.rootViewController = tabBarControlloer
        
        return true
        
    }
    


}

