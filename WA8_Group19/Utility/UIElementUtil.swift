//
//  UIElementUtil.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/8/23.
//

import UIKit

class UIElementUtil {
    
    // create customized text field
    static func createAndAddTextField(to view: UIView, placeHolder: String, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.font = UIFont.systemFont(ofSize: Constants.FONT_REGULAR)
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }
    
    // create customized label
    static func createAndAddLabel(to view: UIView, text: String, fontSize: CGFloat, isCenterAligned: Bool, isBold: Bool, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize): label.font.withSize(fontSize)
        label.textColor = textColor
        label.textAlignment = isCenterAligned ? .center : .left
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    // create customized button
    static func createAndAddButton(to view: UIView, title: String, color: UIColor, titleColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.FONT_REGULAR, weight: .bold)
        button.backgroundColor = color
        button.setTitleColor(titleColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    // crate a button that displays a menu
    static func createAndAddMenuButton(to view: UIView, title: String) -> UIButton {
        let menuButton = UIButton(type: .system)
        menuButton.setTitle(title, for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButton)
        return menuButton
    }
    
    // create a button that displays a photo
    static func createAndAddPhotoButton(to view: UIView, imageName: String, tintColor: UIColor) -> UIButton {
        let photoButton = UIButton(type: .system)
        photoButton.setTitle("", for: .normal)
        photoButton.setImage(UIImage(systemName: imageName), for: .normal)
        photoButton.tintColor = tintColor
        photoButton.contentHorizontalAlignment = .fill
        photoButton.contentVerticalAlignment = .fill
        photoButton.imageView?.contentMode = .scaleAspectFit
        photoButton.showsMenuAsPrimaryAction = true
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoButton)
        return photoButton
    }
    
    // create customized picker view
    static func createAndAddPickerView(to view: UIView) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.isUserInteractionEnabled = true
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        // the following code snippet is borrowed from the piazza discussion
        // essentially we are setting the height of the upper and lower display area
        // try set 100 to different values and explore the difference
        let pickerHeightConstraint = pickerView.heightAnchor.constraint(equalToConstant: 100)
        pickerHeightConstraint.priority = .defaultHigh
        pickerHeightConstraint.isActive = true
        view.addSubview(pickerView)
        return pickerView
    }
    
    // create customized image view
    static func createAndAddImageView(to view: UIView, imageName: String, color: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }
    
    // create customized table view
    static func createAndAddTablesView(to view: UIView) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        return tableView
    }
    
    // create customized scroll view
    static func createAndAddScrollView(to view: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        return scrollView
    }
    
    // create customized text view
    static func createAndAddTextView(to view: UIView, text: String, fontSize: CGFloat, isEditable: Bool, isScrollable: Bool) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.isEditable = isEditable
        textView.isScrollEnabled = isScrollable
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        return textView
    }
    
    // create customized search bar
    static func createSearchBar(placeHolder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeHolder
        return searchBar
    }
}
