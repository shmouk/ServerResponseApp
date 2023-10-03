//
//  AppDelegate.swift
//  ServerResponseApp
//
//  Created by Марк on 3.10.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    private let viewController = ViewController()
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return true
    }
}

