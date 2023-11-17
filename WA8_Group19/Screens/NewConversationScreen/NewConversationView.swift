//
//  NewConversationView.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import UIKit

class NewConversationView: UIView {
    var searchResultTableView: UITableView!
    var emptyResultLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUIElements()
        initConstraints()
    }
    
    func setupUIElements() {
        // Table view
        searchResultTableView = UIElementUtil.createAndAddTablesView(to: self)
        searchResultTableView.register(SearchResultTableViewCell.self,
                                       forCellReuseIdentifier: SearchResultTableViewCell.IDENTIFIER)
        searchResultTableView.isHidden = true
        
        // Label
        emptyResultLabel = UIElementUtil.createAndAddLabel(to: self,
                                                           text: "No Results",
                                                           fontSize: Constants.FONT_REGULAR,
                                                           isCenterAligned: true,
                                                           isBold: false,
                                                           textColor: .systemGray)
        emptyResultLabel.isHidden = true
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Table view
            searchResultTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            searchResultTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
            searchResultTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.VERTICAL_MARGIN_REGULAR),
            searchResultTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.VERTICAL_MARGIN_REGULAR),
            
            // Empty search label
            emptyResultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyResultLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
