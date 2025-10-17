//
//  LoginViewController.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//

import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: ProfileViewModel

    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = Theme.background
        title = "Log In"

        titleLabel.text = "CinemaPoint"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textColor = Theme.textPrimary

        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none

        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        [loginButton, registerButton].forEach {
            $0.layer.cornerRadius = 10
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
            $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
            $0.setTitleColor(.white, for: .normal)
        }

        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = Theme.accent

        registerButton.setTitle("Sign Up", for: .normal)
        registerButton.backgroundColor = .systemGray

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, emailField, passwordField, loginButton, registerButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc private func loginTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        viewModel.login(email: email, password: password) { [weak self] error in
            if let error = error {
                Toast.show(message: error, in: self?.view ?? UIView())
            }
        }
    }

    @objc private func registerTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        viewModel.register(email: email, password: password) { [weak self] error in
            if let error = error {
                Toast.show(message: error, in: self?.view ?? UIView())
            } else {
                Toast.show(message: "Account created!", in: self?.view ?? UIView())
            }
        }
    }
}
