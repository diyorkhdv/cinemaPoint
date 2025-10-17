//
//  ProfileCoordinator.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//

import UIKit
import FirebaseAuth

final class ProfileCoordinator {
    var navigationController: UINavigationController
    var onLogout: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showProfile()
        navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
    }

    func showProfile() {
        let vm = ProfileViewModel()
        let vc = ProfileViewController(viewModel: vm)
        vm.onLogout = { [weak self] in
            self?.onLogout?()
        }
        navigationController.setViewControllers([vc], animated: false)
    }
}
