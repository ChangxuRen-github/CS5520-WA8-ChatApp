//
//  ConversationView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit

class ConversationView: UIView {
    
    var conversationTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        initConstraints()
    }
    
    func setupTableView() {
        conversationTableView = UIElementUtil.createAndAddTablesView(to: self)
        conversationTableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "conversations")
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            conversationTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            conversationTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
            conversationTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            conversationTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
