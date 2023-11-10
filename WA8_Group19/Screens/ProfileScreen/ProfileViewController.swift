//
//  ProfileViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import UIKit

class ProfileViewController: UIViewController {

    // initialize profile view
    let profileView = ProfileView()

    // spinner
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addTargetToButtons()
        getProfile()
    }
    
    func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Your Profile"
    }
    
    func getProfile() {
        guard let uid = AuthManager.shared.uid else {
            AlertUtil.showErrorAlert(viewController: self,
                                     title: "Error!",
                                     errorMessage: "Please sign in.")
            self.transitionToLoginScreen()
            return
        }
        print(uid)
        self.showActivityIndicator()
        DBManager.dbManager.getUser(withUID: uid) { result in
            self.hideActivityIndicator()
            switch result {
            case .success(let user):
                print("User retrieved: \(user)")
                self.displayProfile(with: user)

            case .failure(let error):
                print("Error retrieving user: \(error.localizedDescription)")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Failed to retrieve your profile: \(error.localizedDescription)")
            }
        }
    }
    
    func displayProfile(with user: User) {
        profileView.nameLabel.text = "\(user.displayName)"
        profileView.emailLabel.text = "\(user.email)"
        profileView.memberSinceLabel.text = "\(DateFormatter.formatDate(user.createdAt))"
    }
}

// Action listeners
extension ProfileViewController {
    
    func addTargetToButtons() {
        profileView.logoutButton.addTarget(self, action: #selector(onLogoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func onLogoutButtonTapped() {
        showActivityIndicator()
        AuthManager.shared.signOut{ result in
            hideActivityIndicator()
            switch result {
            case .success():
                print("User successfully log out.")
                print("User sign status: \(AuthManager.shared.isUserSignedIn())")
                self.transitionToLoginScreen()

            case .failure(let error):
                print("Sign out failed: \(error.localizedDescription)")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Error: Sign out failed: \(error.localizedDescription)")
            }
        }
    }
}

// Transition between screens
extension ProfileViewController {
    func transitionToLoginScreen() {
        // TODO: implement transtition
        print("Transition to log in screen.")
    }
}

// Spinner
extension ProfileViewController: ProgressSpinnerDelegate {
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
