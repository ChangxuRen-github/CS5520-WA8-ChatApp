//
//  RegisterView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit

class RegisterView: UIView {

    // image height
    let IMAGE_HEIGHT = CGFloat(100)
    // image width
    let IMAGE_WIDTH = CGFloat(110)
    
    var contentWrapper: UIScrollView!
    var photoPickerButton: UIButton!
    var photoPickerLabel: UILabel!
    var registerButton: UIButton!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var passwordConfirmTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUIComponents()
        initConstraints()
    }
    
    func setupUIComponents() {
        contentWrapper = UIElementUtil.createAndAddScrollView(to: self)
        photoPickerButton = UIElementUtil.createAndAddPhotoButton(to: contentWrapper,
                                                                  imageName: "camera.fill",
                                                                  tintColor: .systemGray)
        photoPickerLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                           text: "Add profile photo",
                                                           fontSize: Constants.FONT_SMALL,
                                                           isCenterAligned: true,
                                                           isBold: true,
                                                           textColor: .black)
        nameTextField = UIElementUtil.createAndAddTextField(to: contentWrapper,
                                                            placeHolder: "Name",
                                                            keyboardType: .default)
        emailTextField = UIElementUtil.createAndAddTextField(to: contentWrapper,
                                                             placeHolder: "Email",
                                                             keyboardType: .emailAddress)
        passwordTextField = UIElementUtil.createAndAddTextField(to: contentWrapper,
                                                                placeHolder: "Password",
                                                                keyboardType: .default)
        passwordTextField.isSecureTextEntry = true
        passwordConfirmTextField = UIElementUtil.createAndAddTextField(to: contentWrapper,
                                                                       placeHolder: "Confirm password",
                                                                       keyboardType: .default)
        passwordConfirmTextField.isSecureTextEntry = true
        registerButton = UIElementUtil.createAndAddButton(to: contentWrapper,
                                                          title: "Register",
                                                          color: .systemGreen,
                                                          titleColor: .white)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            photoPickerButton.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            photoPickerButton.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            photoPickerButton.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH),
            photoPickerButton.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT),
            
            photoPickerLabel.topAnchor.constraint(equalTo: photoPickerButton.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL),
            photoPickerLabel.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            photoPickerLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            photoPickerLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            nameTextField.topAnchor.constraint(equalTo: photoPickerLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            nameTextField.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTextField.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            emailTextField.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            emailTextField.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            passwordTextField.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            passwordTextField.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordConfirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            passwordConfirmTextField.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            passwordConfirmTextField.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            passwordConfirmTextField.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 50),
        
            registerButton.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            registerButton.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            registerButton.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            registerButton.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            registerButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
