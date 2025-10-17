//
//  AppCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 15/10/25.
//

import UIKit
import FirebaseAuth
// MARK: - Coordinator Protocol
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainTabBarCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if Auth.auth().currentUser != nil {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator?.onLoginSuccess = { [weak self] in
            self?.showMainFlow()
        }
        authCoordinator?.start()
    }

    private func showMainFlow() {
        mainCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        mainCoordinator?.onLogout = { [weak self] in
            self?.showAuthFlow()
        }
        mainCoordinator?.start()
    }
}
