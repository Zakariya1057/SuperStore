//
//  FeedbackModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Feedback
{
    // MARK: Use cases
    enum GetTitle
    {
      struct Request
      {
      }
        
      struct Response
      {
          var title: String
      }
        
      struct ViewModel
      {
          var title: String
      }
    }
    
    enum SendFeedback
    {
        struct Request
        {
            var message: String
        }
        
        struct Response
        {
            var error: String?
        }
        
        struct ViewModel
        {
            var error: String?
        }
    }
    
    enum SendMessage
    {
        struct Request
        {
            var message: MessageModel
        }
        
        struct Response
        {
            var sentMessage: MessageModel
            var error: String?
        }
        
        struct ViewModel
        {
            var sentMessage: MessageModel
            var error: String?
        }
    }
    
    enum GetMessages
    {
        struct Request
        {
        }
        
        struct Response
        {
            var messages: [MessageModel]
            var error: String?
        }
        
        struct ViewModel
        {
            var messages: [MessageModel]
            var error: String?
        }
    }
}
