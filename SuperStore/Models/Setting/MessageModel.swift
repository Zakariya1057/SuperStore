//
//  MessageModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct MessageModel {
    var text: String
    var type: MessageType
    var createdAt: Date
}

enum MessageType {
    case sent, received
}
