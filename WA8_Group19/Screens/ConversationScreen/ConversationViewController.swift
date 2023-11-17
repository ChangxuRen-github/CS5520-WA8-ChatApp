//
//  ConversationViewController.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import FirebaseFirestore

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

class ConversationViewController: MessagesViewController {
    // current conversation
    let conversation: Conversation
    // current user
    let thisUser: FirebaseAuth.User
    // user to chat with
    let thatUser: User
    // sender: a model that complies with MessageKit
    let thisSender: SenderType
    
    // Spinner
    private let childProgressView = ProgressSpinnerViewController()
    
    // firestore listener
    private var messagesListener: ListenerRegistration?
    
    // message array
    var messages = [Message]()

    // DEBUG:
    let mockSender = Sender(
        senderId: "0", displayName: "Changxu"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ******************** DEBUG START****************************
        //messages.append(Message(sender: mockSender, messageId: "1", sentDate: Date(), kind: .text("Hello!!")))
        //messages.append(Message(sender: mockSender, messageId: "1", sentDate: Date(), kind: .text("I am writing a new messageI am writing a new")))
        //messages.append(Message(sender: mockSender, messageId: "1", sentDate: Date(timeIntervalSinceNow: 3748972), kind: .text("Hello!!")))
        // ******************** DEBUG END****************************

        doDelegations()
        setupMediaInputButton()
        setupMessagesListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToLastItem()
    }
    
    init(with thisUser: FirebaseAuth.User, with thatUser: User, with conversation: Conversation) {
        self.thisUser = thisUser
        self.thatUser = thatUser
        self.conversation = conversation
        self.thisSender = Sender(senderId: thisUser.uid, displayName: thisUser.displayName ?? "Me")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // setup listener
    private func setupMessagesListener() {
        guard let conversationId = conversation.uuid else {
            print("Error: no conversation id found.")
            return
        }
        
        messagesListener = DBManager.dbManager.database
                .collection(DBManager.dbManager.CONVERSATIONS_COLLECTION)
                .document(conversationId)
                .collection(DBManager.dbManager.MESSAGES_SUBCOLLECTION)
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("Error getting messages at MessagesListener: \(error)")
                        return
                    }

                    querySnapshot?.documentChanges.forEach { change in
                        if change.type == .added {
                            // Deserialize the MessageDAO object
                            if let messageDAO = try? change.document.data(as: MessageDAO.self) {
                                // Convert MessageDAO to MessageKit's MessageType
                                let newMessage = self.convertDAOToMessageKitMessage(messageDAO)
                                self.messages.append(newMessage)
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem()
                            }
                        }
                    }
                }
    }
    
    // TODO: this needs modification
    private func convertDAOToMessageKitMessage(_ messageDAO: MessageDAO) -> Message {
        let sender = Sender(senderId: messageDAO.senderId, displayName: messageDAO.senderName)
        if messageDAO.isImage {
            guard let url = URL(string: messageDAO.imageURL!),
                let placeholder = UIImage(systemName: "plus") else {
                return Message(sender: sender,
                               messageId: messageDAO.uuid ?? UUID().uuidString,
                               sentDate: messageDAO.timestamp ?? Date(),
                               kind: .text(messageDAO.content))
            }

            let size = CGSize(width: 200, height: 200)
            let media = Media(url: url,
                              image: nil,
                              placeholderImage: placeholder,
                              size: size)
            
            return Message(sender: sender,
                           messageId: messageDAO.uuid ?? UUID().uuidString,
                           sentDate: messageDAO.timestamp ?? Date(),
                           kind: .photo(media))
        } else {
            return Message(sender: sender,
                           messageId: messageDAO.uuid ?? UUID().uuidString,
                           sentDate: messageDAO.timestamp ?? Date(),
                           kind: .text(messageDAO.content))
        }
    }
    
    deinit {
        messagesListener?.remove()
    }
}

extension ConversationViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func doDelegations() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
    }
    
    // determine the current sender is
    var currentSender: MessageKit.SenderType {
        // DEBUG:
         //return mockSender
        return thisSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // give different color to message bubble so that we can differentiate the outgoing and incoming messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .link : .secondarySystemBackground
    }
    
    // define avatar for this and that users
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == thisSender.senderId {
            avatarView.set(avatar: Avatar(image: UIImage(systemName: "apple.logo")))
        } else {
            avatarView.set(avatar: Avatar(image: UIImage(systemName: "apple.terminal")))
        }
        // fit to scale
        avatarView.contentMode = .scaleAspectFit
        avatarView.backgroundColor = UIColor.clear
    }
    
    // show message sender name above the message bubble
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name,
                                  attributes: [
                                    .font: UIFont.preferredFont(forTextStyle: .caption1),
                                    .foregroundColor: UIColor(white: 0.3, alpha: 1)
                                  ])
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return Constants.VERTICAL_MARGIN_REGULAR // Adjust as needed, current is 16
    }
    
    // show message sending time below the message bubble
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = DateFormatter.formatDate(message.sentDate)
        return NSAttributedString(string: dateString,
                                  attributes: [
                                    .font: UIFont.preferredFont(forTextStyle: .caption1),
                                    .foregroundColor: UIColor(white: 0.3, alpha: 1)
                                  ])
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return Constants.VERTICAL_MARGIN_REGULAR // Adjust as needed, current is 16
    }
    
    // show tail effect of message bubble
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
      let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(corner, .curved)
    }

    // configure how message cell display image
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
}

extension ConversationViewController: MessageCellDelegate {
    // open MessageImageViewScreen when tap on the image message
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let messageImageViewScreenViewController = MessageImageViewScreenViewController(with: imageUrl)
            navigationController?.pushViewController(messageImageViewScreenViewController, animated: true)
        default:
            break
        }
    }
}

// - Input Bar management
extension ConversationViewController: InputBarAccessoryViewDelegate {
    // triggered when send button is tapped
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        guard let conversationId = conversation.uuid else {
            print("Error: no conversation id found.")
            return
        }
        print("\(currentSender.displayName) is sending \(text) at \(Date())")
        
        let newMessage = MessageDAO(uuid: nil,
                                    timestamp: Date(),
                                    senderId: thisUser.uid,
                                    senderName: thisSender.displayName,
                                    content: text)

        self.showActivityIndicator()
        DBManager.dbManager.addMessage(conversationId: conversationId,
                                       message: newMessage) { success in
            self.hideActivityIndicator()
            if success {
                print("Message sent successfully!")
                inputBar.inputTextView.text = ""
            } else {
                print("Failed to send message!")
                AlertUtil.showErrorAlert(viewController: self,
                                         title: "Error!",
                                         errorMessage: "Failed to send message, please try again!")
            }
        }
    }
}

// -Media input management
extension ConversationViewController {
    // MARK: set up the media message input button. Right now, we can attach photo.
    private func setupMediaInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip.badge.ellipsis"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
}

// -Image picker
extension ConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let conversationId = conversation.uuid else {
            print("Error: no conversation id found.")
            return
        }
        print("\(currentSender.displayName) is sending a image message at \(Date())")
        
        let newMessage = MessageDAO(uuid: nil,
                                    timestamp: Date(),
                                    senderId: thisUser.uid,
                                    senderName: thisSender.displayName,
                                    content: "Image message.",
                                    isImage: true)
        
        if let image = info[.editedImage] as? UIImage {
            self.showActivityIndicator()
            DBManager.dbManager.addImageMessage(conversationId: conversationId, message: newMessage, image: image) { success in
                self.hideActivityIndicator()
                if success {
                    print("Image message successfully added.")
                } else {
                    print("Failed to add image message.")
                    AlertUtil.showErrorAlert(viewController: self,
                                             title: "Error!",
                                             errorMessage: "Failed to send an image message, please try again!")
                }
            }
        }
    }
}


// - Spinner
extension ConversationViewController: ProgressSpinnerDelegate {
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
