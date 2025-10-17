//
//  AuthCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//


import UIKit

final class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    var onLoginSuccess: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = ProfileViewModel()
        let vc = LoginViewController(viewModel: vm)
        vm.onLoginSuccess = { [weak self] in
            self?.onLoginSuccess?()
        }

        navigationController.setViewControllers([vc], animated: false)
        navigationController.isNavigationBarHidden = true
    }
}
