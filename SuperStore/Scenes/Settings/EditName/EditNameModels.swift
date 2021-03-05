//
//  EditNameModels.swift
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

enum EditName
{
    // MARK: Use cases
    
    enum GetName
    {
        struct Request
        {
        }
        struct Response
        {
            var name: String
        }
        struct ViewModel
        {
            var name: String
        }
    }
    
    enum UpdateName {
        struct Request
        {
            var name: String
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