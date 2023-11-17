//
//  RegisterViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit
import PhotosUI
import FirebaseAuth

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    var pickedImage = UIImage(systemName: "person.circle")
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        setupPhotoPickerButton()
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
    
    func setupPhotoPickerButton() {
        registerView.photoPickerButton.menu = getMenuImagePicker()
    }
    
    func setNameOfTheUserInFirebaseAuth(user: User){
        showActivityIndicator()
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.commitChanges(completion: { ( error ) in
            self.hideActivityIndicator()
            if error == nil {
                self.showActivityIndicator()
                DBManager.dbManager.addUser(with: user, profileImage: self.pickedImage!) { success in
                    self.hideActivityIndicator()
                    if success {
                        self.alertAndTransition()
                        print("Add user to firestore successfully.")
                    } else {
                        // TODO: may need to figure out a way to handle this data discrepency
                        print("Failed to add user to firestore.")
                        AlertUtil.showErrorAlert(viewController: self,
                                                 title: "Error!",
                                                 errorMessage: "Failed to add user to firestore. Please try again.")
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
    
}


// - Action listener
extension RegisterViewController {
    
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
                                    conversationIds: [])
                    user.createdAt = nil
                    self.setNameOfTheUserInFirebaseAuth(user: user)
                }
            }
        }
    }
    
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera.
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    //MARK: pick Photo using Gallery.
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
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

extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        print(results)
        let itemprovider = results.map(\.itemProvider)
        for item in itemprovider {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async {
                        if let uwImage = image as? UIImage {
                            self.registerView.photoPickerButton.setImage (
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedImage = uwImage
                        }
                    }
                })
            }
        }
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            self.registerView.photoPickerButton.setImage (
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            print("Error: picking profile image using camera failed.")
        }
    }
}

// - Validation
extension RegisterViewController {
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
    
    func isValidEmail(text email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func arePasswordSame(password firstTimeEntered: String, password secondTimeEntered: String) -> Bool {
        return firstTimeEntered == secondTimeEntered
    }
}

// - Spinner
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
