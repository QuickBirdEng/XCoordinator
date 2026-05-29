//
//  AppDelegate.swift
//  XCoordinatorTestHost
//
//  Minimal scene-based host application for running XCoordinatorTests.
//  UIKit view-controller presentation only works when a real UIWindowScene
//  exists, which a bare SwiftPM test bundle does not provide — hence this host.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }

}
