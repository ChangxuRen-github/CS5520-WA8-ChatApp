//
//  NewConversationViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import UIKit

class NewConversationViewController: UIViewController {
    public var completion: ((User) -> (Void))?
    // initialize new conversation view
    let newConversationView = NewConversationView()
    
    // Spinner
    let childProgressView = ProgressSpinnerViewController()
    
    // Search Bar
    let searchBar: UISearchBar = UIElementUtil.createSearchBar(placeHolder: "Search for users...")
    
    // Users list
    var users = [User]()
    
    // Filtered users
    var results = [User]()
    
    var hasFetchedUsersFromFirestore = false
    
    override func loadView() {
        view = newConversationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newConversationView.searchResultTableView.separatorStyle = .none
        setupNavBar()
        setupSearchBar()
        doTabelViewDelegations()
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissViewController))
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
}

// - Action listeners
extension NewConversationViewController {
    // Dismiss new conversation view controller
    @objc func dismissViewController() {
        print("Dismiss the current view controller")
        dismiss(animated: true, completion: nil)
    }
}

// - Search bar
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        self.showActivityIndicator()
        searchUsers(query: text)
    }

    func searchUsers(query: String) {
        if (hasFetchedUsersFromFirestore) {
            filterUsers(with: query)
        } else {
            DBManager.dbManager.getUsers { [weak self] result in
                switch result {
                case .success(let users):
                    print("Successfully fetched users: \(users)")
                    self?.hasFetchedUsersFromFirestore = true
                    self?.users = users
                    self?.filterUsers(with: query)
                    
                case .failure(let error):
                    // Handle any errors
                    print("Error fetching users: \(error)")
                }
            }
        }
    }

    func filterUsers(with term: String) {
        guard let currentUserAuth = AuthManager.shared.currentUser, hasFetchedUsersFromFirestore else {
            return
        }
        
        self.hideActivityIndicator()
        let lowercasedTerm = term.lowercased()
        // Create a Set from currentUser's conversationIds for efficient lookup
        let currentUser = users.filter { $0.uid == currentUserAuth.uid }[0]
        let currentUserConversationIds = Set(currentUser.conversationIds)

        self.results = users.filter { user in
            // Filter out the current logged in user
            if user.uid == currentUser.uid { return false }

            // Filter out users who have common conversationIds with currentUser
            let hasCommonConversationId = user.conversationIds.contains { currentUserConversationIds.contains($0) }
            // C. Ren: if we do not want to show users who already had a conversation with current user enable below line
            // if hasCommonConversationId { return false }

            let email = user.email.lowercased()
            let displayName = user.displayName.lowercased()
            
            // Check if displayName or email matches the search term
            return displayName.hasPrefix(lowercasedTerm) || email.hasPrefix(lowercasedTerm)
        }
        
        showSearchResults()
    }

    func showSearchResults() {
        if (results.isEmpty) {
            newConversationView.emptyResultLabel.isHidden = false
            newConversationView.searchResultTableView.isHidden = true
        } else {
            newConversationView.emptyResultLabel.isHidden = true
            newConversationView.searchResultTableView.isHidden = false
            newConversationView.searchResultTableView.reloadData()
        }
    }
}

// - Table view
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    // delegations
    func doTabelViewDelegations() {
        newConversationView.searchResultTableView.delegate = self
        newConversationView.searchResultTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.IDENTIFIER,
                                                 for: indexPath) as! SearchResultTableViewCell
        cell.config(with: model)
        return cell
    }

    // Start a new conversation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
        let targetUser = results[indexPath.row]

        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUser)
        })
    }
}

// - Spinner
extension NewConversationViewController: ProgressSpinnerDelegate {
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
