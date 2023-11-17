//
//  User.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    let uid: String
    let email: String
    let displayName: String
    var conversationIds: [String]
    // profileImageURL save the url of the image from firebase storage
    var profileImageURL: String?
    // Use the property wrapper for automatic handling
    // If createdAt is nil, Firestore will automatically fill it with the server's current timestamp.
    @ServerTimestamp var createdAt: Date?
}
