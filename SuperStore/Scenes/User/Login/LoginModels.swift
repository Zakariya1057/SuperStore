//
//  LoginModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AuthenticationServices

enum Login
{
    // MARK: Use cases
    
    enum Login
    {
        struct Request
        {
            var email: String
            var password: String
            var notificationToken: String?
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
    
    enum AppleLogin {
        struct Request
        {
            var appleIDCredential: ASAuthorizationAppleIDCredential
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
