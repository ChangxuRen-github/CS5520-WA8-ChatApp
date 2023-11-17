//
//  EditProfileViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/16/23.
//

import UIKit
import PhotosUI
import FirebaseAuth

class EditProfileViewController: UIViewController {
    // initialize edit profile view
    let editProfileView = EditProfileView()
    
    // spinner
    let childProgressView = ProgressSpinnerViewController()
    
    // saves the current User information
    let currentProfile: User
    
    // saves the new User informaion
    var newProfile: User?
    
    var currentProfileImage: UIImage
    
    init(with currentProfile: User, with currentProfileImage: UIImage) {
        self.currentProfile = currentProfile
        self.currentProfileImage = currentProfileImage
        super.init(nibName: nil, bundle: nil)
        self.displayProfile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoPickerButton()
        addTargetToButtons()
        hideKeyboardOnTapOutside()
    }
    
    func setupPhotoPickerButton() {
        editProfileView.photoPickerButton.menu = getMenuImagePicker()
    }
    
    func alertAndTransition() {
        let alert = UIAlertController(title: "Update Successful", message: "Profile has been updated!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            print("Transition from edit profile screen to conversations screen.")
            let conversationsViewController = ConversationsViewController()
            var viewControllers = self.navigationController!.viewControllers
            viewControllers.removeAll()
            viewControllers.append(conversationsViewController)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }))
        if self.presentedViewController == nil { // this makes sure only one error alert at a time
            self.present(alert, animated: true)
        }
    }

    func displayProfile() {
        editProfileView.nameTextField.text = "\(currentProfile.displayName)"
        editProfileView.emailLabel.text = "\(currentProfile.email)"
        editProfileView.memberSinceLabel.text = "\(DateFormatter.formatDate(currentProfile.createdAt))"
        editProfileView.photoPickerButton.setImage (
            currentProfileImage.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
    }
}

// - Action listener
extension EditProfileViewController {
    
    func addTargetToButtons() {
        editProfileView.updateButton.addTarget(self, action: #selector(onUpdateButtonTapped), for: .touchUpInside)
    }
    
    @objc func onUpdateButtonTapped() {
        guard let text = editProfileView.nameTextField.text, !text.isEmpty, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Error: name field must be filled!")
            return
        }
        self.showActivityIndicator()
        self.newProfile = User(uid: currentProfile.uid,
                               email: currentProfile.email,
                               displayName: text,
                               conversationIds: currentProfile.conversationIds,
                               createdAt: currentProfile.createdAt)
        DBManager.dbManager.updateUser(user: newProfile!, profileImage: currentProfileImage) { success in
            self.hideActivityIndicator()
            if success {
                print("User profile successfully updated.")
                self.setNameOfTheUserInFirebaseAuth(user: self.newProfile!)
            } else {
                print("Failed to update user profile.")
                AlertUtil.showErrorAlert(viewController: self, title: "Error!", errorMessage: "Failed to update user profile. Please try again!")
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
                self.alertAndTransition()
            }else{
                print("Error occured: \(String(describing: error))")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Error occured: \(String(describing: error))")
            }
        })
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

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        print(results)
        let itemprovider = results.map(\.itemProvider)
        for item in itemprovider {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async {
                        if let uwImage = image as? UIImage {
                            self.editProfileView.photoPickerButton.setImage (
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.currentProfileImage = uwImage
                        }
                    }
                })
            }
        }
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            self.editProfileView.photoPickerButton.setImage (
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.currentProfileImage = image
        }else{
            print("Error: picking profile image using camera failed.")
        }
    }
}

// - Spinner
extension EditProfileViewController: ProgressSpinnerDelegate {
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
