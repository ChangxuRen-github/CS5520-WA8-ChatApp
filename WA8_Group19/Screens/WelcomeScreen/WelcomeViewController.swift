//
//  WelcomeViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/8/23.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    // delay time
    let DELAY_TIME = 1.0
    
    // initialize welcome view
    let welcomeView = WelcomeView()
    
    // firebase authentication
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    // add welcome view to view controller
    override func loadView() {
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add auth state listener with delay
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.DELAY_TIME) {
                if user != nil {
                    self.transitionToConversationsScreen()
                } else {
                    self.transitionToLoginPage()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove auth state listener
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func transitionToConversationsScreen() {
        print("Transition to conversations screen.")
        let conversationsViewController = ConversationsViewController()
        var viewControllers = self.navigationController!.viewControllers
        viewControllers.removeAll()
        viewControllers.append(conversationsViewController)
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    func transitionToLoginPage() {
        print("Transition to Login screen.")
        let loginViewController = LoginViewController()
        var viewControllers = self.navigationController!.viewControllers
        viewControllers.removeAll()
        viewControllers.append(loginViewController)
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
