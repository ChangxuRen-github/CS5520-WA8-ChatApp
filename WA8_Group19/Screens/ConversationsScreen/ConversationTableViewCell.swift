//
//  ConversationTableViewCell.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
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
                                                    text: "Default Name",
                                                    fontSize: Constants.FONT_REGULAR,
                                                    isCenterAligned: false,
                                                    isBold: true,
                                                    textColor: UIColor.black)
        timeLabel = UIElementUtil.createAndAddLabel(to: wrapperCellView,
                                                    text: "Default Time",
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
    
    func config(with model: Conversation) {
        // TODO: config the cell
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
            lastMessageLabel.widthAnchor.constraint(lessThanOrEqualTo: nameLabel.widthAnchor),
            
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
