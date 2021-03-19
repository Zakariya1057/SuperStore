//
//  EditListItemModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum EditListItem
{
    // MARK: Use cases
    struct DisplayedListItem {
        var name: String
        var image: String?
        var weight: String?
        var quantity: Int
        var price: String
        
        var promotion: DisplayedPromotion?
    }
    
    struct DisplayedPromotion {
        var name: String
    }
    
    enum GetListItem
    {
        struct Request
        {
        }
        struct Response
        {
            var listItem: ListItemModel
        }
        struct ViewModel
        {
            var displayedListItem: DisplayedListItem
        }
    }
    
    enum UpdateListItem
    {
        struct Request
        {
        }
        struct Response
        {
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var error: String?
            var offline: Bool = false
        }
    }
    
    enum UpdateQuantity
    {
        struct Request
        {
            var quantity: Int
        }
        struct Response
        {
            var listItem: ListItemModel
            var offline: Bool = false
        }
        struct ViewModel
        {
            var displayedListItem: DisplayedListItem
            var offline: Bool = false
        }
    }
    
    enum DeleteListItem
    {
        struct Request
        {
        }
        struct Response
        {
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var error: String?
            var offline: Bool = false
        }
    }
}
