//
//  SettingsModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Settings
{
    // MARK: Use cases
    
    struct DisplayUserSection {
        var title: String = ""
        var fields: [DisplayUserField]
    }
    
    struct DisplayUserField {
        var name: String
        var value: String? = nil
        var on: Bool = false
        var type: DisplayUserFieldType
    }
    
    enum DisplayUserFieldType {
        case name, email, store, password, notification
        case feedback, reportIssue
        case logout, login
    }
    
    enum GetUserDetails
    {
        struct Request
        {
        }
        
        struct Response
        {
            var user: UserModel?
        }
        
        struct ViewModel
        {
            var displayUserSections: [DisplayUserSection]
            var loggedIn: Bool
        }
    }
    
    enum GetStore
    {
        struct Request
        {
        }
        struct Response
        {
            var storeName: String
        }
        struct ViewModel
        {
            var storeName: String
        }
    }
    
    enum UpdateNotifications
    {
        struct Request
        {
            var sendNotifications: Bool
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
    
    enum Logout
    {
        struct Request
        {
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
    
    enum Delete
    {
        struct Request
        {
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
