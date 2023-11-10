//
//  DateFormatter.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/10/23.
//

import Foundation

class DateFormatter {
    static func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }

        let formatter = Foundation.DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
