//
//  ShowListModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowList
{
    struct DisplayedListCategory {
        var name: String
        var items: [DisplayedListItem]
    }

    struct DisplayedListItem {
        var name: String
        var productID: Int
        var quantity: Int
        var totalPrice: String
        var tickedOff: Bool
    }

    struct DisplayedList {
        var id: Int
        var name: String
        var categories: [DisplayedListCategory]

        var oldTotalPrice: String?
        var totalPrice: String
    }
    
    struct DisplayedListPrice {
        var totalPrice: String
        var oldTotalPrice: String?
    }
    
    enum GetList
    {
        struct Request
        {
            var listID: Int
        }
        
        struct Response
        {
            var list: ListModel?
            var error: String?
            var offline: Bool = false
        }
        
        struct ViewModel
        {
            var displayedList: DisplayedList?
            var error: String?
            var offline: Bool = false
        }
    }
    
    enum UpdateListItem
    {
        struct Request
        {
            var productID: Int
            var quantity: Int
            var tickedOff: Bool
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
    
    enum UpdateListTotal
    {
        struct Request
        {
        }
        
        struct Response
        {
            var list: ListModel
        }
        
        struct ViewModel
        {
            var displayedPrice: DisplayedListPrice
        }
    }

    enum DeleteListItem
    {
        struct Request
        {
            var productID: Int
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
