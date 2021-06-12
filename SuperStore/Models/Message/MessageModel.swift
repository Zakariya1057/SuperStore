//
//  MessageModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct MessageModel {
    var id: Int = 1
    var type: FeedbackType
    var text: String
    var direction: MessageDirection
    var status: MessageStatus = .success
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

extension MessageModel: Equatable {
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.text == rhs.text &&
            lhs.direction == rhs.direction &&
            lhs.status == rhs.status &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt
    }
}

enum MessageDirection: String {
    case sent, received
}

enum MessageStatus: String {
    case success
    case progress
    case error
}
