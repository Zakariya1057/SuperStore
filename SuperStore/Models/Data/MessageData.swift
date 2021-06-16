//
//  MessageModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 09/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct MessagesDataResponse: Decodable {
    var data: [MessageData]
}

struct MessageDataResponse: Decodable {
    var data: MessageData
}

struct MessageData: Decodable {
    var id: Int
    
    var text: String
    
    var type: String
    var direction: String
    
    var message_read: Bool
    
    var created_at: String
    var updated_at: String
    
    func getMessaageModel() -> MessageModel {
        let dateWorker = DateWorker()
        
        let createdDate: Date = dateWorker.formatDate(date: created_at)
        let updatedData: Date = dateWorker.formatDate(date: updated_at)
        
        return MessageModel(
            id: id,
            type: FeedbackType.init(rawValue: type)!,
            text: text,
            direction: MessageDirection(rawValue: direction)!,
            read: true,
            createdAt: createdDate,
            updatedAt: updatedData
        )
    }
}
