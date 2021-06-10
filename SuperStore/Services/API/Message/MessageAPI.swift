//
//  MessageAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/06/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class MessageAPI: API, MessageRequestProtocol {
    
    func getMessages(type: FeedbackType, completionHandler: @escaping (_ messages: [MessageModel], _ error: String?) -> Void){
        let url: String = "\(Config.Route.Message.All)?type=\(type)"
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let messagesDataResponse =  try self.jsonDecoder.decode(MessagesDataResponse.self, from: data)
                let messages = self.createMessagesModel(messagesDataResponse: messagesDataResponse)
                completionHandler(messages, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get messages. Decoding error, please try again later.")
            }
        }
    }
    
    func sendMessage(type: FeedbackType, message: String, completionHandler: @escaping (MessageModel?, String?) -> Void) {
        requestWorker.post(url: Config.Route.Message.Create, data: ["type": type.rawValue, "message": message]) { (response: () throws -> Data) in
            do {
                let data = try response()
                let messageDataResponse =  try self.jsonDecoder.decode(MessageDataResponse.self, from: data)
                let message = self.createMessageModel(messageDataResponse: messageDataResponse)
                completionHandler(message, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Failed to send message. Decoding error, please try again later.")
            }
        }
    }
    
}

extension MessageAPI {
    
    private func createMessagesModel(messagesDataResponse: MessagesDataResponse?) -> [MessageModel] {
        
        if let messagesDataResponse = messagesDataResponse {
            let messages = messagesDataResponse.data
            return messages.map{ $0.getMessaageModel() }
        }
        
        return []
    }
    
    private func createMessageModel(messageDataResponse: MessageDataResponse?) -> MessageModel? {
        if let messageDataResponse = messageDataResponse {
            return messageDataResponse.data.getMessaageModel()
        }
        
        return nil
    }
}

