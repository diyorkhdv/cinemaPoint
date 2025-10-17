//
//  SceneDelegate.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navController)
        appCoordinator?.start()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
        
        window.overrideUserInterfaceStyle = .unspecified // позволяет iOS переключать light/dark автоматически
        UINavigationBar.appearance().tintColor = Theme.accent
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Theme.textPrimary]
        UITabBar.appearance().tintColor = Theme.accent
    }
}

