//
//  AuthManager.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()

    private init() {}

    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }

    var uid: String? {
        return currentUser?.uid
    }

    var email: String? {
        return currentUser?.email
    }

    var displayName: String? {
        return currentUser?.displayName
    }

    func isUserSignedIn() -> Bool {
        return currentUser != nil
    }

    func signIn(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            } else {
                let error = NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred, when signing in."])
                completion(.failure(error))
            }
        }
    }

    func signOut(completion: (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
}
