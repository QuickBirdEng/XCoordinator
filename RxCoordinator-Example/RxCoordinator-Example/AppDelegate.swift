//
//  AppDelegate.swift
//  RxCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit
import rx_coordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AnyCoordinator<MainRoute>!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let window = self.window else { return false }

        coordinator = AnyCoordinator(BasicCoordinator<MainRoute>(initalRoute: .login, initalLoadingType: .immediately))
        window.rootViewController = coordinator.navigationController

        return true
    }
}

