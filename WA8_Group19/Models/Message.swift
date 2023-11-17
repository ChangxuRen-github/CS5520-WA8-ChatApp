//
//  Message.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageDAO: Codable {
    @DocumentID var uuid: String?
    @ServerTimestamp var timestamp: Date?
    let senderId: String
    let senderName: String
    let content: String
}
