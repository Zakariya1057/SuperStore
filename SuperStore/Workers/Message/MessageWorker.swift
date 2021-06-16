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
    
    private lazy var notificationWorker: NotificationWorker = NotificationWorker()
    
    init(messageAPI: MessageRequestProtocol) {
        self.messageAPI = messageAPI
        self.messageStore = MessageRealmStore()
    }
    
    func getMessages(type: FeedbackType, completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void){
        let savedMessages: [MessageModel] = messageStore.getMessages(type: type)
        if savedMessages.count > 0 {
            completionHandler(savedMessages, nil)
        }
        
        notificationWorker.updateBadgeNumber()
        
        messageAPI.getMessages(type: type) { (messages: [MessageModel], error: String?) in
            if error == nil {
                self.messageStore.saveMessages(type: type, messages: messages)
            }
            
            // Combine returned successfull messages with failed outgoing messages and sort by date
            completionHandler( self.combineMessages(savedMessages: savedMessages, receivedMessages: messages) , error)
        }
    }
    
    func sendMessage(type: FeedbackType, message sendingMessage: MessageModel, completionHandler: @escaping (_ error: String?) -> Void){
        messageAPI.sendMessage(type: type, message: sendingMessage.text, completionHandler: { (message: MessageModel?, error: String?) in
            
            self.messageStore.deleteFailedMessage(message: sendingMessage)
            
            if let message = message {
                self.messageStore.saveMessage(message: message)
            } else if error != nil {
                self.messageStore.saveFailedMessage(message: sendingMessage)
            }
            
            completionHandler(error)
        })
    }
    
}

extension MessageWorker {
    func getUnreadMessagesCount() -> Int {
        return messageStore.getUnreadMessagesCount()
    }
    
    func getUnreadMessagesCountByType(type: FeedbackType) -> Int {
        return messageStore.getUnreadMessagesCountByType(type: type)
    }
}

extension MessageWorker {
    func combineMessages(savedMessages: [MessageModel], receivedMessages: [MessageModel]) -> [MessageModel] {
        var combinedMessages: [MessageModel] = receivedMessages
        
        savedMessages.filter({ message in message.status == .error }).forEach { message in combinedMessages.append(message) }
        
        return combinedMessages.sorted(by: { messageA, messageB in
            return messageA.createdAt < messageB.createdAt
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
    
    func saveMessages(messages: [MessageModel])
    
    func deleteFailedMessage(message: MessageModel)
    
    func saveMessage(message: MessageModel)
    func saveFailedMessage(message: MessageModel)
    
    func getUnreadMessagesCount() -> Int
    func getUnreadMessagesCountByType(type: FeedbackType) -> Int
}
