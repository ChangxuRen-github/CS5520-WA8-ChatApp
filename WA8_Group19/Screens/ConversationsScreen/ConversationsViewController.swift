//
//  ConversationsViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ConversationsViewController: UIViewController {
    // initialize conversation view
    private let conversationsView = ConversationsView()
    
    // Spinner
    private let childProgressView = ProgressSpinnerViewController()
    
    // current user
    private var currentUser: FirebaseAuth.User!
    
    // firestore listener
    private var conversationsListener: ListenerRegistration?
    
    // initialize conversations array
    var conversations = [Conversation]()
    
    override func loadView() {
        view = conversationsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove separator lines for table view
        conversationsView.conversationsTableView.separatorStyle = .none
        doTableViewDelegations()
        setupNavBar()
        setupCurrentUser() // --- must above the following setups: C.Ren
        setupConversationsListener()
    }
    
    func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(onComposeButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onProfileButtonTapped))
    }
    
    func setupCurrentUser() {
        guard let uwUser = AuthManager.shared.currentUser else {
            AlertUtil.showErrorAlert(viewController: self,
                                     title: "Error!",
                                     errorMessage: "Please sign in.")
            self.transitionToLoginScreen()
            return
        }
        self.currentUser = uwUser
    }
    
    func setupConversationsListener() {
        // Set up the listener
        conversationsListener = DBManager.dbManager.database.collection(DBManager.dbManager.CONVERSATIONS_COLLECTION)
            .whereField("participantIds", arrayContains: currentUser.uid)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting conversations: \(error)")
                    return
                }
                
                // Handle the document changes
                querySnapshot?.documentChanges.forEach { change in
                    switch change.type {
                    case .added:
                        // Deserialize and add the new Conversation object
                        if let conversation = try? change.document.data(as: Conversation.self) {
                            self.conversations.append(conversation)
                        }
                        
                    case .modified:
                        // Update the existing Conversation object
                        if let conversation = try? change.document.data(as: Conversation.self),
                           let index = self.conversations.firstIndex(where: { $0.uuid == conversation.uuid }) {
                            self.conversations[index] = conversation
                        }
                        
                    case .removed:
                        // Handle conversation removal if necessary
                        break
                    }
                    
                    // TODO: Update UI here, reload the table view -Done
                    self.conversationsView.conversationsTableView.reloadData()
                }
            }
    }
    
    deinit {
        // clean up listener when view controller is deinitialized
        conversationsListener?.remove()
    }
}

// - Action listeners.
extension ConversationsViewController {
    // transition to profile screen
    @objc func onProfileButtonTapped() {
        print("Transition to profile screen.")
        transitionToProfileScreen()
    }
    
    @objc func onComposeButtonTapped() {
        // TODO: transition to new conversation screen -Done
        print("Transition to new conversation screen.")
        let newConversationViewController = NewConversationViewController()
        newConversationViewController.completion = { [weak self] thatUser in
            guard let strongSelf = self else { return }
            
            let currentConversations = strongSelf.conversations
            
            if let targetConversation = currentConversations.first(where: {
                $0.participantIds.contains(thatUser.uid) // if a previous conversation exists between the current user and thatUser
            }) {
                // TODO: just use targetConversation and continue that conversation -Done
                // TODO: Transition to conversation screen -Done
                print("To conversation screen with \(targetConversation)")
                strongSelf.transitionToConversationScreen(with: strongSelf.currentUser, with: thatUser, with: targetConversation)
            } else {
                // if no previous conversation exists, create a new one
                strongSelf.createNewConversation(with: strongSelf.currentUser, with: thatUser)
            }
        }
        // transition to new conversation view, in which we can search for the participant
        // it has to be presented in modal model (e.g., has its own navigation controller), otherwise dismiss function won't work
        present(UINavigationController(rootViewController: newConversationViewController), animated: true)
    }
}

// - Create conversation
extension ConversationsViewController {
    func createNewConversation(with thisUser: FirebaseAuth.User, with thatUser: User) {
        let creatorId = thisUser.uid
        let participantId = thatUser.uid
        
        DBManager.dbManager.createConversationBetween(creatorId: creatorId, participantId: participantId) { result in
            switch result {
            case .success(let conversation):
                print("Conversation created successfully: \(conversation)")
                // TODO: Transition to conversation screen -Done
                // Now, we created a new conversation between two users. We can use this conversation to create the conversation screen
                print("To conversation screen with \(conversation)")
                self.transitionToConversationScreen(with: thisUser, with: thatUser, with: conversation)
                
            case .failure(let error):
                print("Error creating conversation: \(error)")
            }
        }
    }
}

// Transition between screens
extension ConversationsViewController {
    
    func transitionToLoginScreen() {
        // TODO: clear the stack and add log in screen -Done
        let loginViewController = LoginViewController()
        var viewControllers = self.navigationController!.viewControllers
        viewControllers.removeAll()
        viewControllers.append(loginViewController)
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    func transitionToProfileScreen() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func transitionToConversationScreen(with thisUser: FirebaseAuth.User, with thatUser: User, with conversation: Conversation) {
        let conversationViewController = ConversationViewController(with: thisUser, with: thatUser, with: conversation)
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

// -Table views
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    // delegations
    func doTableViewDelegations() {
        conversationsView.conversationsTableView.delegate = self
        conversationsView.conversationsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableViewCell.IDENTIFIER,
                                                 for: indexPath) as! ConversationsTableViewCell
        let conversationModel = conversations[indexPath.row]
        cell.config(with: conversationModel, with: currentUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("index \(indexPath.row) is clicked") DEBUG
        tableView.deselectRow(at: indexPath, animated: true)
        openConversation(with: conversations[indexPath.row])
    }
    
    func openConversation(with conversation: Conversation) {
        // TODO: transition to Conversation Screen -Done
        self.showActivityIndicator()
        // Iterate the participantIds and find thatUser's uid
        let thatUserId = conversation.participantIds.first(where: {
            $0 != currentUser.uid
        })
        guard let thatUserId = thatUserId else {
            print("Conversation only contains the current user, no other user has been found!")
            return
        }
        // Retrieve User object of thatUser
        DBManager.dbManager.getUser(withUID: thatUserId) { result in
            self.hideActivityIndicator()
            switch result {
            case .success(let thatUser):
                // retrieve that user successful, transition to conversation screen
                self.transitionToConversationScreen(with: self.currentUser, with: thatUser, with: conversation)
            case .failure(let error):
                print("Error retrieving user: \(error.localizedDescription)")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Failed to retrieve user with uid \(thatUserId): \(error.localizedDescription)")
            }
        }
    }
}

// - Spinner
extension ConversationsViewController: ProgressSpinnerDelegate {
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
