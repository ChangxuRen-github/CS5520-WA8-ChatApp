//
//  ConversationsViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit

class ConversationsViewController: UIViewController {
    // initialize conversation view
    let conversationView = ConversationView()
    
    // initialize notification center
    let notificationCenter = NotificationCenter.default
    
    // initialize conversations array
    var conversations = [Conversation]()
    
    override func loadView() {
        view = conversationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove separator lines for table view
        conversationView.conversationTableView.separatorStyle = .none
        doDelegations()
        addTargetToButtons()
        setupNavBar()
        //setupNotificationCenter()
        //getAllNotes()
    }
    
    
    func doDelegations() {
        conversationView.conversationTableView.delegate = self
        conversationView.conversationTableView.dataSource = self
    }
    
    func setupNavBar() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "Chats"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(onLogoutButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(onProfileButtonTapped))
    }
    
    func setupNotificationCenter() {
        //notificationCenter.addObserver(self, selector: #selector(updateNotes(notification:)), name: .updateNotes, object: nil)
    }
    
    func addTargetToButtons() {
        //notesPageView.addNoteButton.addTarget(self, action: #selector(onAddNoteButtonTapped), for: .touchUpInside)
    }
    
    @objc func updateNotes(notification: Notification) {
        //self.notes.removeAll()
        //self.notesPageView.notesTableView.reloadData()
        //self.getAllNotes()
    }

}

// - Action listeners.
extension ConversationsViewController {
    // transition to profile screen
    @objc func onProfileButtonTapped() {
        // TODO: transition to profile screen
        print("Transition to profile screen.")
    }
    
    // TODO: implement the following func
    // transition to new conversation screen
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversations", for: indexPath) as! ConversationTableViewCell
        let conversationModel = conversations[indexPath.row]
        cell.config(with: conversationModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: initialize the note detail view controller and push it to the navigation controller
        // print("index \(indexPath.row) is clicked") DEBUG
        tableView.deselectRow(at: indexPath, animated: true)
        openConversation(with: conversations[indexPath.row])
        // let noteDetailPageViewController = NoteDetailPageViewController()
        // noteDetailPageViewController.note = self.notes[indexPath.row]
        // navigationController?.pushViewController(noteDetailPageViewController, animated: true)
        //self.displayDetailSelectedFor(note: self.notes[indexPath.row])
    }
    
    func openConversation(with conversation: Conversation) {
        // TODO: transition to Conversation Screen
        print("Transition to conversation screen.")
    }
}
