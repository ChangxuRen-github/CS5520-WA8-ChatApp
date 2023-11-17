//
//  EditProfileView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/16/23.
//

import UIKit

class EditProfileView: UIView {
    // image height
    let IMAGE_HEIGHT = CGFloat(100)
    // image width
    let IMAGE_WIDTH = CGFloat(100)
    // declare UI elements
    var contentWrapper: UIScrollView!
    var profileImage: UIImageView!
    
    var photoPickerButton: UIButton!
    var photoPickerLabel: UILabel!
    
    var nameTagLabel: UILabel!
    var nameTextField: UITextField!
    var emailTagLabel: UILabel!
    var emailLabel: UILabel!
    var memeberSinceTagLabel: UILabel!
    var memberSinceLabel: UILabel!
    var updateButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUIComponents()
        initConstraints()
    }
    
    func setupUIComponents() {
        contentWrapper = UIElementUtil.createAndAddScrollView(to: self)
        photoPickerButton = UIElementUtil.createAndAddPhotoButton(to: contentWrapper,
                                                                  imageName: "camera.fill",
                                                                  tintColor: .systemGray)
        photoPickerLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                           text: "Edit profile photo",
                                                           fontSize: Constants.FONT_SMALL,
                                                           isCenterAligned: true,
                                                           isBold: true,
                                                           textColor: .black)
        nameTagLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                    text: "Name:",
                                                    fontSize: Constants.FONT_REGULAR,
                                                    isCenterAligned: false,
                                                    isBold: false,
                                                    textColor: UIColor.black)
        nameTextField = UIElementUtil.createAndAddTextField(to: contentWrapper,
                                                            placeHolder: "Name",
                                                            keyboardType: .default)
        emailTagLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                     text: "Email:",
                                                     fontSize: Constants.FONT_REGULAR,
                                                     isCenterAligned: false,
                                                     isBold: false,
                                                     textColor: UIColor.black)
        emailLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                     text: "Email is loading",
                                                     fontSize: Constants.FONT_REGULAR,
                                                     isCenterAligned: false,
                                                     isBold: false,
                                                     textColor: UIColor.black)
        memeberSinceTagLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                           text: "Member since: ",
                                                           fontSize: Constants.FONT_REGULAR,
                                                           isCenterAligned: false,
                                                           isBold: false,
                                                           textColor: UIColor.black)
        memberSinceLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                           text: "--, --, --",
                                                           fontSize: Constants.FONT_REGULAR,
                                                           isCenterAligned: false,
                                                           isBold: false,
                                                           textColor: UIColor.black)
        updateButton = UIElementUtil.createAndAddButton(to: contentWrapper,
                                                        title: "Update",
                                                        color: .link,
                                                        titleColor: .white)
    }
    
    // initializing UI contraints
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
            
            nameTagLabel.topAnchor.constraint(equalTo: photoPickerLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            nameTagLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            nameTagLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTagLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            nameTextField.topAnchor.constraint(equalTo: nameTagLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            nameTextField.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTextField.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTagLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            emailTagLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            emailTagLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            emailTagLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            emailLabel.topAnchor.constraint(equalTo: emailTagLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL),
            emailLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            emailLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            memeberSinceTagLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            memeberSinceTagLabel.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            memeberSinceTagLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            memeberSinceTagLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
        
            memberSinceLabel.topAnchor.constraint(equalTo: memeberSinceTagLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL),
            memberSinceLabel.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            memberSinceLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            memberSinceLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            updateButton.topAnchor.constraint(equalTo: memberSinceLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            updateButton.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            updateButton.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            updateButton.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            updateButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
