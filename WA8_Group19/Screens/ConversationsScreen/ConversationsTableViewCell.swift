//
//  ConversationTableViewCell.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit
import FirebaseAuth

class ConversationsTableViewCell: UITableViewCell {
    static let IDENTIFIER: String = "conversations"
    let CELL_BORDER_WIDTH: CGFloat  = 1
    let CELL_BORDER_RADIUS: CGFloat = 10
    let CELL_HEIGHT: CGFloat = 20
    var wrapperCellView: UITableView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var lastMessageLabel: UILabel!
    var profilePhoto: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
        initConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // source: https://www.youtube.com/watch?v=1KILMba7I8Q
        wrapperCellView.frame = wrapperCellView.frame.inset(by: UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5))
    }
    
    func setupUIElements() {
        wrapperCellView = UIElementUtil.createAndAddTablesView(to: self)
        wrapperCellView.layer.borderColor = UIColor.gray.cgColor
        wrapperCellView.layer.borderWidth = CELL_BORDER_WIDTH // 1
        wrapperCellView.layer.cornerRadius = CELL_BORDER_RADIUS // 8
        nameLabel = UIElementUtil.createAndAddLabel(to: wrapperCellView,
                                                    text: "Name",
                                                    fontSize: Constants.FONT_REGULAR,
                                                    isCenterAligned: false,
                                                    isBold: true,
                                                    textColor: UIColor.black)
        timeLabel = UIElementUtil.createAndAddLabel(to: wrapperCellView,
                                                    text: "",
                                                    fontSize: Constants.FONT_SMALL,
                                                    isCenterAligned: false,
                                                    isBold: false,
                                                    textColor: UIColor.black)
        lastMessageLabel = UIElementUtil.createAndAddLabel(to: wrapperCellView,
                                                           text: "Last Message..",
                                                           fontSize: Constants.FONT_SMALL,
                                                           isCenterAligned: false,
                                                           isBold: false,
                                                           textColor: UIColor.black)
        profilePhoto = UIElementUtil.createAndAddImageView(to: wrapperCellView,
                                                           imageName: "person",
                                                           color: .link)
    }
    
    func config(with model: Conversation, with thisUser: FirebaseAuth.User) {
        // TODO: config the cell
        let thatUserId = model.participantIds.filter { $0 != thisUser.uid}[0]
        // Retrieve User object of thatUser
        DBManager.dbManager.getUser(withUID: thatUserId) { result in
            switch result {
            case .success(let thatUser):
                self.nameLabel.text = "\(thatUser.displayName)"
                if model.lastMessageTimestamp != nil {
                    self.timeLabel.text = "\(DateFormatter.formatDate(model.lastMessageTimestamp))"
                }
                if model.lastMessageText != nil {
                    self.lastMessageLabel.text = "\(model.lastMessageText ?? "No message found.")"
                } else {
                    self.lastMessageLabel.text = "No message found."
                    self.lastMessageLabel.lineBreakMode = .byTruncatingTail
                }
            case .failure(let error):
                print("Error retrieving user: \(error.localizedDescription)")
            }
        }
    }
    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            profilePhoto.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: Constants.HORIZONTAL_MARGIN_SMALL),
            profilePhoto.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            profilePhoto.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -CELL_HEIGHT),
            profilePhoto.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -CELL_HEIGHT),
            
            nameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: Constants.VERTICAL_MARGIN_SMALL), // 4
            nameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: Constants.HORIZONTAL_MARGIN_SMALL),
            nameLabel.heightAnchor.constraint(equalToConstant: CELL_HEIGHT), //20
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL), // 4
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: CELL_HEIGHT),
            timeLabel.widthAnchor.constraint(lessThanOrEqualTo: nameLabel.widthAnchor),
            
            lastMessageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Constants.VERTICAL_MARGIN_SMALL),
            lastMessageLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            lastMessageLabel.heightAnchor.constraint(equalToConstant: CELL_HEIGHT),
            lastMessageLabel.trailingAnchor.constraint(equalTo: wrapperCellView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.HORIZONTAL_MARGIN_TINY),
            //lastMessageLabel.widthAnchor.constraint(lessThanOrEqualTo: nameLabel.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 3 * (CELL_HEIGHT + Constants.VERTICAL_MARGIN_SMALL) + Constants.VERTICAL_MARGIN_REGULAR)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
