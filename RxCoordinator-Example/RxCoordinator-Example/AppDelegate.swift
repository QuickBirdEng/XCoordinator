//
//  AppDelegate.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = self.window else { return false }

        let rootVC = UINavigationController()
        window.rootViewController = rootVC

        coordinator = MainCoordinator(context: rootVC)
        coordinator.start()

        return true
    }
}

