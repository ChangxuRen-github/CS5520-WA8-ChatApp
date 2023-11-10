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
    var currentUser: FirebaseAuth.User?
    
    // add welcome view to view controller
    override func loadView() {
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // schedule the function call with a delay
        DispatchQueue.global().asyncAfter(deadline: .now() + DELAY_TIME, execute: self.checkAndDoTransition)
    }
    
    func checkAndDoTransition() {
        if currentUser != nil {
            // if the current user already logged in, transition to chats
            DispatchQueue.main.async {
                self.transitionToNotesPage()
            }
        } else {
            // if the current user has not logged in, transition to login page
            DispatchQueue.main.async {
                self.transitionToLoginPage()
            }
        }
    }
    
    func transitionToNotesPage() {
        print("Transition to chats screen.")
        //let notesPageViewController = NotesPageViewController()
        //var viewControllers = self.navigationController!.viewControllers
        //viewControllers.removeAll()
        //viewControllers.append(notesPageViewController)
        //self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    func transitionToLoginPage() {
        print("Transition to Login screen.")
        //let loginSignupPageViewController = LoginSignupPageViewController()
        //var viewControllers = self.navigationController!.viewControllers
        //viewControllers.removeAll()
        //viewControllers.append(loginSignupPageViewController)
        //self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
