//
//  ShowProductResultsModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowProductResults
{
    // MARK: Use cases
    
    enum GetResults
    {
        struct Request
        {
            var page: Int = 1
            var refine: Bool
        }
        struct Response
        {
            var products: [ProductModel]
            var paginate: PaginateResultsModel?
            
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var products: [ProductModel]
            var paginate: PaginateResultsModel?
            
            var error: String?
            var offline: Bool = false
        }
    }
    
    enum GetCategoryProducts
    {
        struct Request
        {
            var page: Int = 1
            var refine: Bool
        }
        struct Response
        {
            var category: ChildCategoryModel?
            
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var category: ChildCategoryModel?
            
            var error: String?
            var offline: Bool = false
        }
    }
    
    
    enum GetListItems
    {
        struct Request
        {
        }
        struct Response
        {
            var listItems: [ListItemModel]
        }
        struct ViewModel
        {
            var listItems: [Int: ListItemModel]
        }
    }
    
    enum CreateListItem {
        struct Request
        {
            var listID: Int
            var product: ProductModel
        }
        struct Response
        {
            var listItem: ListItemModel?
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var listItem: ListItemModel?
            var error: String?
            var offline: Bool = false
        }
    }
    
    enum UpdateListItem {
        struct Request
        {
            var listID: Int
            var productID: Int
            var quantity: Int
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
