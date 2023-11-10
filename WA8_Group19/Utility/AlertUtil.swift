//
//  AlertUtil.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/8/23.
//

import UIKit

class AlertUtil {
    static func showErrorAlert(viewController: UIViewController, title: String, errorMessage: String) {
        let alert = UIAlertController(
            title: title,
            message: errorMessage,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if viewController.presentedViewController == nil { // this makes sure only one error alert at a time
            viewController.present(alert, animated: true)
        }
    }
}
