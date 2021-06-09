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
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

enum MessageDirection: String {
    case sent, received
}
