//
//  MainTabBarController.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.tintColor = Theme.accent
        tabBar.barTintColor = Theme.background
        tabBar.backgroundColor = Theme.background
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.isTranslucent = true
    }
}
