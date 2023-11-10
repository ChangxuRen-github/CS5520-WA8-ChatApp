//
//  LoginViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//
// TODO: we can improve the cx by allowing the user to login by tapping the enter.

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        addTargetToButtons()
        hideKeyboardOnTapOutside()
        
    }
    
    func addTargetToButtons() {
        loginView.loginButton.addTarget(self, action: #selector(onLoginButtonTapped), for: .touchUpInside)
    }
    
    func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(onRegisterButtonTapped))
    }
    
    @objc func onRegisterButtonTapped() {
        // TODO: transition to register screen.
        print("Transition to register screen.")
    }
    
    @objc func onLoginButtonTapped() {
        // TODO: handle login logics
        print("Login button tapped.")
        // check if email is filled
        guard let email = loginView.emailTextField.text, !email.isEmpty, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Email must be filled!")
            return
        }
        // check if password is filled
        guard let password = loginView.passwordTextField.text, !password.isEmpty, !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Password must be filled!")
            return
        }
        
        // call firebase auth to login
        showActivityIndicator()
        AuthManager.shared.signIn(email: email, password: password) { [weak self] (result: Result<FirebaseAuth.User, Error>) in
            guard let strongSelf = self else { return }
            strongSelf.hideActivityIndicator()
            
            switch result {
            case .failure(let error as NSError):
                // Handle the error more specifically if needed
                // TODO: figure out how to access the underlying error.
                var errorMessage = "Invalid email or wrong password!"
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    errorMessage = "No user found with this email. Please register first."
                } else if error.code == AuthErrorCode.wrongPassword.rawValue {
                    errorMessage = "Incorrect password. Please try again."
                } else {
                    // Handle other possible errors
                    errorMessage = error.localizedDescription
                }
                AlertUtil.showErrorAlert(viewController: strongSelf, title: "Error!", errorMessage: errorMessage)

            case .success(let user):
                // The user is signed in, perform any operations after successful sign-in
                print("Sign in successful for user: \(user.email ?? "No email")")
                strongSelf.transitionToChatsScreen()
            }
        }
    }
    
    func transitionToChatsScreen() {
        // TODO: transition to chats page
        print("Transition to chats page.")
    }
    
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

extension LoginViewController: ProgressSpinnerDelegate {
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
