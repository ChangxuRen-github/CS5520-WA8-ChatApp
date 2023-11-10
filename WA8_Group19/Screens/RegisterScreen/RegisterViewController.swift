//
//  RegisterViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        addTargetToButtons()
        hideKeyboardOnTapOutside()
    }
    
    func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Register"
    }

    func addTargetToButtons() {
        registerView.registerButton.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
    }

    @objc func onRegisterButtonTapped() {
        print("Register button tapped.") // LOG: register button tapped
        if (!isInputValid()) { return } // Sanity check
        
        showActivityIndicator() 
        // network call to register user
        if let name = registerView.nameTextField.text,
           let email = registerView.emailTextField.text,
           let password = registerView.passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                self.hideActivityIndicator()
                if let error = error as NSError? {
                    var errorMessage = "There was an error registering."
                    if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        // The email is already in use with another account
                        print("The email address is already in use by another account.")
                        errorMessage = "The email address is already in use by another account."
                    } else if error.code == AuthErrorCode.weakPassword.rawValue {
                        print("The password is too weak.")
                        errorMessage = "The password is too weak."
                    } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                        print("Invalid email format.")
                        errorMessage = "Invalid email format."
                    } else {
                        // Some other error occurred
                        print("Error creating user: \(error.localizedDescription)")
                        errorMessage = "Error creating user: \(error.localizedDescription)"
                    }
                    AlertUtil.showErrorAlert(viewController: self,
                                             title: "Error!",
                                             errorMessage: errorMessage)
                } else {
                    // User creation successful
                    print("User created: \(authResult?.user.uid ?? "No UID")")
                    var user = User(uid: authResult?.user.uid ?? "No UID",
                                    email: email,
                                    displayName: name,
                                    conversations: [])
                    user.createdAt = nil
                    self.setNameOfTheUserInFirebaseAuth(user: user)
                }
            }
        }
    }
    
    func setNameOfTheUserInFirebaseAuth(user: User){
        showActivityIndicator()
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.commitChanges(completion: { ( error ) in
            self.hideActivityIndicator()
            if error == nil {
                self.showActivityIndicator()
                DBManager.dbManager.addUser(with: user) { success in
                    self.hideActivityIndicator()
                    if success {
                        self.alertAndTransition()
                        print("Add user to firestore successfully.")
                    } else {
                        // TODO: may need to figure out a way to handle this data discrepency
                        print("Failed to add user to firestore.")
                    }
                }
            }else{
                print("Error occured: \(String(describing: error))")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Error occured: \(String(describing: error))")
            }
        })
    }
    
    func alertAndTransition() {
        let alert = UIAlertController(title: "Register Successful", message: "Please login with your email and password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        if self.presentedViewController == nil { // this makes sure only one error alert at a time
            self.present(alert, animated: true)
        }
    }
    
    
    func isInputValid() -> Bool {
        let textFields: [UITextField] = [
            registerView.nameTextField,
            registerView.emailTextField,
            registerView.passwordTextField,
            registerView.passwordConfirmTextField
        ]
        
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Error: \(textField.tag.description) field must be filled!")
                return false
            }
            
            if (textField == registerView.emailTextField && !isValidEmail(text: text)) {
                AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Invalid Email Address!")
                return false
            } else if (textField == registerView.passwordConfirmTextField && !arePasswordSame(password: registerView.passwordTextField.text ?? "", password: text)) {
                AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Password does not match!")
                return false
            }
        }
        
        return true
    }
    
    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    func isValidEmail(text email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func arePasswordSame(password firstTimeEntered: String, password secondTimeEntered: String) -> Bool {
        return firstTimeEntered == secondTimeEntered
    }
}

extension RegisterViewController: ProgressSpinnerDelegate {
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
