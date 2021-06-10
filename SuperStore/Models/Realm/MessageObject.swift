//
//  MessageObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class MessageObject: Object {
    @objc dynamic var id: Int = 1
    
    @objc dynamic var type: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var direction: String = ""
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var updatedAt: Date = Date()
    
    func getMessageModel() -> MessageModel {
        return MessageModel(
            id: id,
            type: FeedbackType.init(rawValue: type)!,
            text: text,
            direction: MessageDirection.init(rawValue: direction)!,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
