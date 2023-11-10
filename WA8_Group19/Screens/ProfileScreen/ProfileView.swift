//
//  ProfileView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import UIKit

class ProfileView: UIView {
    // image height
    let IMAGE_HEIGHT = CGFloat(150)
    // image width
    let IMAGE_WIDTH = CGFloat(200)
    // declare UI elements
    var contentWrapper: UIScrollView!
    var profileImage: UIImageView!
    var nameTagLabel: UILabel!
    var nameLabel: UILabel!
    var emailTagLabel: UILabel!
    var emailLabel: UILabel!
    var memeberSinceTagLabel: UILabel!
    var memberSinceLabel: UILabel!
    var logoutButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUIComponents()
        initConstraints()
    }
    
    func setupUIComponents() {
        contentWrapper = UIElementUtil.createAndAddScrollView(to: self)
        profileImage = UIElementUtil.createAndAddImageView(to: contentWrapper,
                                                           imageName: "waveform.and.person.filled",
                                                           color: .link)
        nameTagLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                    text: "Name:",
                                                    fontSize: Constants.FONT_REGULAR,
                                                    isCenterAligned: false,
                                                    isBold: false,
                                                    textColor: UIColor.black)
        nameLabel = UIElementUtil.createAndAddLabel(to: contentWrapper,
                                                    text: "Name is loading",
                                                    fontSize: Constants.FONT_REGULAR,
                                                    isCenterAligned: false,
                                                    isBold: false,
                                                    textColor: UIColor.black)
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
        logoutButton = UIElementUtil.createAndAddButton(to: contentWrapper,
                                                        title: "Log Out",
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
            
            profileImage.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            profileImage.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH),
            profileImage.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT),
            
            nameTagLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            nameTagLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            nameTagLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            nameTagLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            nameLabel.topAnchor.constraint(equalTo: nameTagLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL),
            nameLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            nameLabel.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            
            emailTagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
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
            
            logoutButton.topAnchor.constraint(equalTo: memberSinceLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            logoutButton.centerXAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.centerXAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            logoutButton.trailingAnchor.constraint(equalTo: contentWrapper.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR),
            logoutButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
