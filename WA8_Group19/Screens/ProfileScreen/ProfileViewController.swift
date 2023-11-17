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
    
    // current user
    var currentUser: User?
    
    // current image
    var currentProfileImage: UIImage?
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onEditButtonTapped))
    }
    
    func getProfile() {
        guard let uid = AuthManager.shared.uid else {
            AlertUtil.showErrorAlert(viewController: self,
                                     title: "Error!",
                                     errorMessage: "Please sign in.")
            self.transitionToLoginScreen()
            return
        }
        // DEBUG: print(uid)
        self.showActivityIndicator()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        DBManager.dbManager.getUser(withUID: uid) { result in
            self.hideActivityIndicator()
            switch result {
            case .success(let user):
                print("User retrieved: \(user)")
                // User retrieved, then we fetch profile image from firebase storage
                self.showActivityIndicator()
                DBManager.dbManager.fetchProfileImage(fromURL: user.profileImageURL ?? "") { fetchedImage in
                    self.hideActivityIndicator()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    if let image = fetchedImage {
                        self.displayProfile(with: user, with: image)
                    } else {
                        AlertUtil.showErrorAlert(viewController: self,
                                                 title: "Error!",
                                                 errorMessage: "Failed to retrieve your profile photo.")
                    }
                }
            case .failure(let error):
                print("Error retrieving user: \(error.localizedDescription)")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Failed to retrieve your profile: \(error.localizedDescription)")
            }
        }
    }
    
    func displayProfile(with user: User, with profileImage: UIImage) {
        self.currentUser = user
        self.currentProfileImage = profileImage
        profileView.nameLabel.text = "\(user.displayName)"
        profileView.emailLabel.text = "\(user.email)"
        profileView.memberSinceLabel.text = "\(DateFormatter.formatDate(user.createdAt))"
        profileView.profileImage.image = profileImage
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
    
    @objc func onEditButtonTapped() {
        // TODO: edit init() and initialize edit profile view controller here
        guard let currentUser = self.currentUser, let currentProfileImage = self.currentProfileImage else {
            print("User information retrieved failed.")
            return
        }
        let editProfileViewController = EditProfileViewController(with: currentUser, with: currentProfileImage)
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }
}

// Transition between screens
extension ProfileViewController {
    func transitionToLoginScreen() {
        // TODO: implement transtition -Done
        print("Transition to log in screen.")
        let loginViewController = LoginViewController()
        var viewControllers = self.navigationController!.viewControllers
        viewControllers.removeAll()
        viewControllers.append(loginViewController)
        self.navigationController?.setViewControllers(viewControllers, animated: true)
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
