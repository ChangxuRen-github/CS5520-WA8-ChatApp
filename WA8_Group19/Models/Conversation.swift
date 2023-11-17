//
//  Conversation.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Conversation: Codable {
    @DocumentID var uuid: String?
    @ServerTimestamp var createdAt: Date?
    let createdBy: String
    let participantIds: [String]
    var lastMessageTimestamp: Date?
    var lastMessageText: String?
}
