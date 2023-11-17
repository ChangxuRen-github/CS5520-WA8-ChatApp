//
//  DBManager.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DBManager {
    // Constants
    let CONVERSATIONS_COLLECTION = "conversations"
    let MESSAGES_SUBCOLLECTION = "messages"
    let USER_COLLECTION = "Users"
    
    // A public share dbManager instance
    public static let dbManager = DBManager()
    
    // Maintain a reference to the database
    public let database = Firestore.firestore()

}

// User management
extension DBManager {
    // Add a new user to the database
    public func addUser(with user: User, completion: @escaping (Bool) -> Void) {
        do {
            try database.collection(USER_COLLECTION).document(user.uid).setData(from: user) { error in
                if let error = error {
                    print("Error: writing user to firestore failed with \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch let error {
            print("Error: writing user to firestore failed with \(error)")
            completion(false)
        }
    }
    
    // Get profile detail from the database
    public func getUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        database
            .collection(USER_COLLECTION)
            .document(uid)
            .getDocument { (document, error) in
                if let error = error {
                    // If there's an error, pass it to the completion handler
                    completion(.failure(error))
                } else {
                    do {
                        if let user = try document?.data(as: User.self) {
                            // Success, pass the user to the completion handler
                            completion(.success(user))
                        } else {
                            // Document exists but couldn't be parsed into a User
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document is not in the correct format"])
                            completion(.failure(error))
                        }
                    } catch {
                        // If there's an error during the conversion, pass it to the completion handler
                        completion(.failure(error))
                    }
                }
            }
    }
    
    // Get all users
    public func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        database.collection(USER_COLLECTION).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var users = [User]()
                
                // Iterate through each document in the snapshot
                for document in querySnapshot!.documents {
                    do {
                        // Directly try to decode the document into User
                        let user = try document.data(as: User.self)
                        users.append(user)
                    } catch {
                        // Handle any errors in conversion
                        print("DBManager: error occured when mapping data to User model.")
                        completion(.failure(error))
                        return
                    }
                }
                print("Inside get users: users are \(users)")
                completion(.success(users))
            }
        }
    }
}

// Conversation management
extension DBManager {

    // 1. Get all conversations given a list of conversation IDs
    public func getConversations(conversationIds: [String], completion: @escaping (Result<[Conversation], Error>) -> Void) {
        let group = DispatchGroup()
        var conversations = [Conversation]()
        var overallError: Error?

        for id in conversationIds {
            group.enter()
            database.collection(CONVERSATIONS_COLLECTION).document(id).getDocument { (document, error) in
                defer { group.leave() }
                if let error = error {
                    overallError = error
                } else if let document = document, let conversation = try? document.data(as: Conversation.self) {
                    conversations.append(conversation)
                }
            }
        }

        group.notify(queue: .main) {
            if let error = overallError {
                completion(.failure(error))
            } else {
                completion(.success(conversations))
            }
        }
    }

    // Get all messages given a conversation ID
    public func getMessages(conversationId: String, completion: @escaping (Result<[MessageDAO], Error>) -> Void) {
        database.collection(CONVERSATIONS_COLLECTION).document(conversationId).collection(MESSAGES_SUBCOLLECTION).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                let messages = documents.compactMap { try? $0.data(as: MessageDAO.self) }
                completion(.success(messages))
            }
        }
    }
    
    // Create a new conversation
    public func createConversationBetween(creatorId: String, participantId: String, completion: @escaping (Result<Conversation, Error>) -> Void) {
        // a UUID for the conversation
        let conversationUUID = UUID().uuidString
        
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            // reference to the new conversation document with custom UUID
            let newConversationRef = self.database.collection(self.CONVERSATIONS_COLLECTION).document(conversationUUID)
            
            // create a new conversation object
            let newConversation = Conversation(uuid: conversationUUID, createdBy: creatorId, participantIds: [creatorId, participantId])
            
            // serialize and set the new conversation data
            do {
                try transaction.setData(from: newConversation, forDocument: newConversationRef)
            } catch let serializeError {
                errorPointer?.pointee = serializeError as NSError
                return nil
            }
            
            // reference to the user documents
            let creatorRef = self.database.collection(self.USER_COLLECTION).document(creatorId)
            let participantRef = self.database.collection(self.USER_COLLECTION).document(participantId)
            
            // Add the new conversationId to both users' conversationIds array
            transaction.updateData(["conversationIds": FieldValue.arrayUnion([conversationUUID])], forDocument: creatorRef)
            transaction.updateData(["conversationIds": FieldValue.arrayUnion([conversationUUID])], forDocument: participantRef)
            
            return newConversation
        }) { (transactionResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let conversation = transactionResult as? Conversation {
                completion(.success(conversation))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transaction failed without an error."])))
            }
        }
    }

    // create a new message given a conversation ID
    public func addMessage(conversationId: String, message: MessageDAO, completion: @escaping (Bool) -> Void) {
        let conversationRef = database.collection(CONVERSATIONS_COLLECTION).document(conversationId)
        let newMessageRef = conversationRef.collection(MESSAGES_SUBCOLLECTION).document() // message.uuid will be generated by firestore
        
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            var newMessage = message
            newMessage.uuid = newMessageRef.documentID
            
            // Serialize and set the new message data
            do {
                try transaction.setData(from: newMessage, forDocument: newMessageRef)
            } catch let serializeError {
                errorPointer?.pointee = serializeError as NSError
                return nil
            }
            
            // Update the last message details in the conversation
            var conversationUpdate: [String: Any] = ["lastMessageText": message.content]
            if let timestamp = message.timestamp {
                conversationUpdate["lastMessageTimestamp"] = timestamp
            } else {
                conversationUpdate["lastMessageTimestamp"] = FieldValue.serverTimestamp()
            }
            transaction.updateData(conversationUpdate, forDocument: conversationRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Failed to execute transaction to add a new message: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Add a new conversationId to a user's conversationIds array
    // TODO: not sure if this is still needed. Consider remove it before release. C.Ren
    public func addConversationIdToUser(userId: String, conversationId: String, completion: @escaping (Bool) -> Void) {
        let userRef = database.collection(USER_COLLECTION).document(userId)

        userRef.updateData([
            "conversationIds": FieldValue.arrayUnion([conversationId])
        ]) { error in
            if let error = error {
                print("Error adding new conversationId to user: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
