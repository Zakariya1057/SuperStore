//
//  MessageWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class MessageWorker
{
    private var messageAPI: MessageRequestProtocol
    private var messageStore: MessageStoreProtocol
    
    init(messageAPI: MessageRequestProtocol) {
        self.messageAPI = messageAPI
        self.messageStore = MessageRealmStore()
    }
    
    func getMessages(type: FeedbackType, completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void){
        
        let messages: [MessageModel] = messageStore.getMessages(type: type)
        if messages.count > 0 {
            completionHandler(messages, nil)
        }
        
        messageAPI.getMessages(type: type) { (messages: [MessageModel], error: String?) in
            if error == nil {
                self.messageStore.saveMessages(type: type, messages: messages)
            }
            
            completionHandler(messages, error)
        }
    }
    
    func sendMessage(type: FeedbackType, message: String, completionHandler: @escaping (_ error: String?) -> Void){
        messageAPI.sendMessage(type: type, message: message, completionHandler: { (message: MessageModel?, error: String?) in
            if let message = message {
                self.messageStore.saveMessage(message: message)
            }
            
            completionHandler(error)
        })
    }
}

protocol MessageRequestProtocol {
    func getMessages(type: FeedbackType, completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void)
    func sendMessage(type: FeedbackType, message: String, completionHandler: @escaping (_ message: MessageModel?, _ error: String?) -> Void)
}

protocol MessageStoreProtocol {
    func getMessages(type: FeedbackType) -> [MessageModel]
    func saveMessages(type: FeedbackType, messages: [MessageModel])
    func saveMessage(message: MessageModel)
    
}
