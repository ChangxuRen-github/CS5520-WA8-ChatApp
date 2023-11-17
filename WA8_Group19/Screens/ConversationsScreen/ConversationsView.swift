//
//  ConversationView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit

class ConversationsView: UIView {
    
    var conversationsTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        initConstraints()
    }
    
    func setupTableView() {
        conversationsTableView = UIElementUtil.createAndAddTablesView(to: self)
        conversationsTableView.register(ConversationsTableViewCell.self, forCellReuseIdentifier: ConversationsTableViewCell.IDENTIFIER)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            conversationsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            conversationsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
            conversationsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            conversationsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
