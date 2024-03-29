//
//  SendEmailModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SendEmail
{
    // MARK: Use cases
    
    enum GetEmail
    {
        struct Request
        {
        }
        struct Response
        {
            var email: String
        }
        struct ViewModel
        {
            var email: String
        }
    }
    enum SendEmail
    {
        struct Request
        {
            var email: String
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
}
