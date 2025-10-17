//
//  ProfileViewModel.swift
//  CinemaPoint
//
//  Created by diyor on 17/10/25.
//

import FirebaseAuth

final class ProfileViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLogout: (() -> Void)?

    var currentUser: User? {
        Auth.auth().currentUser
    }

    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
                self.onLoginSuccess?()
            }
        }
    }

    func register(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
                self.onLoginSuccess?()
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        onLogout?()
    }
}
