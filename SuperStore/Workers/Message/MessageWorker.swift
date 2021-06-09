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
    
    init(messageAPI: MessageRequestProtocol) {
        self.messageAPI = messageAPI
    }
    
    func getMessages(completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void){
        messageAPI.getMessages { (messages: [MessageModel], error: String?) in
            completionHandler(messages, error)
        }
    }
    
    func sendMessage(type: FeedbackType, message: String, completionHandler: @escaping (_ error: String?) -> Void){
        messageAPI.sendMessage(type: type, message: message, completionHandler: { (error) in
            completionHandler(error)
        })
    }
}

protocol MessageRequestProtocol {
    func getMessages(completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void)
    func sendMessage(type: FeedbackType, message: String, completionHandler: @escaping (_ error: String?) -> Void)
}
