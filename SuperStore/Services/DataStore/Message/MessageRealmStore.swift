//
//  MessageRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class MessageRealmStore: DataStore, MessageStoreProtocol {
    
    private func getMessageObjects(type: FeedbackType) -> Results<MessageObject>? {
        return realm?.objects(MessageObject.self).filter("type = %@", type.rawValue).sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    func getMessages(type: FeedbackType) -> [MessageModel] {
        return getMessageObjects(type: type)?.map{ $0.getMessageModel() } ?? []
    }
    
    func saveMessages(type: FeedbackType, messages: [MessageModel]){
        deleteAllMessage(type: type)
       
        for message in messages {
            saveMessage(message: message)
        }
    }
    
    func saveMessage(message: MessageModel){
        try? realm?.write({
            let savedMessage = MessageObject()
            
            savedMessage.id = message.id
            
            savedMessage.text = message.text
            
            savedMessage.type = message.type.rawValue
            savedMessage.direction = message.direction.rawValue
            
            savedMessage.createdAt = message.createdAt
            savedMessage.updatedAt = message.updatedAt
            
            realm?.add(savedMessage)
        })
    }
    
    private func deleteAllMessage(type: FeedbackType){
        if let savedMessages = getMessageObjects(type: type){
            try? realm?.write({
                realm?.delete(savedMessages)
            })
        }
    }
}
