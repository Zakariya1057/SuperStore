//
//  FeedbackWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FeedbackWorker
{
    private var feedbackAPI: FeedbackRequestProtocol
    
    init(feedbackAPI: FeedbackRequestProtocol) {
        self.feedbackAPI = feedbackAPI
    }
    
    func sendFeedback(message: String, completionHandler: @escaping (_ error: String?) -> Void){
        feedbackAPI.sendFeedback(message: message, completionHandler: { (error) in
            completionHandler(error)
        })
    }
}

protocol FeedbackRequestProtocol {
    func sendFeedback(message: String, completionHandler: @escaping (_ error: String?) -> Void)
}
