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
    
    private func getSuccessMessageObjects(type: FeedbackType) -> Results<MessageObject>? {
        return realm?.objects(MessageObject.self).filter("type = %@ and status != %@", type.rawValue, "error").sorted(byKeyPath: "createdAt", ascending: true)
    }
    
    private func getMessageObject(message: MessageModel) -> MessageObject? {
        return realm?.objects(MessageObject.self).filter("""
            id = %@ AND
            type = %@ AND
            text = %@ AND
            direction = %@ AND
            createdAt = %@ AND
            updatedAt = %@
        """, message.id, message.type.rawValue, message.text, message.direction.rawValue, message.createdAt, message.updatedAt).first
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
        if let savedMessage = getMessageObject(message: message){
            updateMessage(message: message, savedMessage: savedMessage)
        } else {
            try? realm?.write({
                let savedMessage = MessageObject()
                setMessageObjectProperties(message: message, savedMessage: savedMessage)
                realm?.add(savedMessage)
            })
        }
    }
    
    func updateMessage(message: MessageModel, savedMessage: MessageObject){
        try? realm?.write({
            setMessageObjectProperties(message: message, savedMessage: savedMessage)
        })
    }
    
    func saveFailedMessage(message: MessageModel){
        var failedMessage: MessageModel = message
        failedMessage.status = .error
        
        saveMessage(message: failedMessage)
    }
    
    func deleteFailedMessage(message: MessageModel){
        if let savedMessage = getMessageObject(message: message){
            deleteMessage(message: savedMessage)
        }
    }
    
    private func deleteAllMessage(type: FeedbackType){
        if let savedMessages = getSuccessMessageObjects(type: type){
            try? realm?.write({
                realm?.delete(savedMessages)
            })
        }
    }
    
    private func deleteMessage(message: MessageObject){
        try? realm?.write({
            realm?.delete(message)
        })
    }
    
}

extension MessageRealmStore {
    func setMessageObjectProperties(message: MessageModel, savedMessage: MessageObject){
        savedMessage.id = message.id
        
        savedMessage.text = message.text
        
        savedMessage.type = message.type.rawValue
        savedMessage.direction = message.direction.rawValue
        savedMessage.status = message.status.rawValue
        
        savedMessage.createdAt = message.createdAt
        savedMessage.updatedAt = message.updatedAt
    }
}
