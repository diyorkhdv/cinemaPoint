//
//  ProfileViewController.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//


import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel

    private let titleLabel = UILabel()
    private let emailLabel = UILabel()
    private let logoutButton = UIButton(type: .system)

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayUserInfo()
    }

    private func setupUI() {
        view.backgroundColor = Theme.background
        title = "Profile"

        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Theme.textPrimary

        emailLabel.font = .systemFont(ofSize: 18)
        emailLabel.textAlignment = .center
        emailLabel.textColor = Theme.textPrimary.withAlphaComponent(0.8)

        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 10
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, emailLabel, logoutButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        logoutButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }

    private func displayUserInfo() {
        guard let user = viewModel.currentUser else {
            titleLabel.text = "No user logged in"
            emailLabel.text = ""
            return
        }

        // Показываем имя, если оно есть (иначе просто email)
        let name = user.displayName ?? "User"
        titleLabel.text = "Welcome, \(name)!"
        emailLabel.text = user.email ?? ""
    }

    @objc private func logoutTapped() {
        viewModel.logout()
        Toast.show(message: "Logged out", in: view)
    }
}
