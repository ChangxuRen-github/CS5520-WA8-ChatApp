//
//  WelcomeView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/8/23.
//

import UIKit

class WelcomeView: UIView {
    // image height
    let IMAGE_HEIGHT = CGFloat(200)
    // image width
    let IMAGE_WIDTH = CGFloat(250)
    
    // welcome page image
    var welcomeImage: UIImageView!
    // welcome page label
    var welcomeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUIComponents()
        initConstraints()
    }
    
    func setupUIComponents() {
        welcomeImage = UIElementUtil.createAndAddImageView(to: self, imageName: "bubble.left.and.text.bubble.right", color: .link)
        welcomeLabel = UIElementUtil.createAndAddLabel(to: self, text: "Welcome to NU messenger!", fontSize: Constants.FONT_REGULAR, isCenterAligned: true, isBold: true, textColor: .black)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            welcomeImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            welcomeImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: IMAGE_WIDTH),
            welcomeImage.heightAnchor.constraint(equalToConstant: IMAGE_HEIGHT),
        
            welcomeLabel.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: Constants.VERTICAL_MARGIN_LARGE),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_REGULAR),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_REGULAR)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
