//
//  ShowProductModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowProduct
{
    // MARK: Use cases
    
    struct DisplayedProduct {
        var id: Int
        var name: String
        var price: String
        var promotion: PromotionModel?
        
        var largeImage: String
        
        var description: String

        var favourite: Bool
        var monitoring: Bool

        var avgRating: Double
        var totalReviewsCount: Int

        var storage: String?
        var weight: String?
        
        var dietaryInfo: String?
        var allergenInfo: String?

        var review: ReviewModel?

        var ingredients: [String]

        var recommended: [ProductModel]
    }
    
    enum GetProduct
    {
        struct Request
        {
        }
        struct Response
        {
            var product: ProductModel?
            var error: String?
        }
        struct ViewModel
        {
            var product: ProductModel?
            var displayedProduct: DisplayedProduct?
            var error: String?
        }
    }
    
    
    enum UpdateFavourite
    {
        struct Request
        {
            var favourite: Bool
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
    
    enum UpdateMonitoring
    {
        struct Request
        {
            var monitor: Bool
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
    
    enum GetListItem
    {
        struct Request
        {
            var listID: Int
            var productID: Int
        }
        struct Response
        {
            var listItem: ListItemModel?
        }
        struct ViewModel
        {
            var listItem: ListItemModel?
        }
    }
    
    enum CreateListItem
    {
        struct Request
        {
            var listID: Int
            var productID: Int
            var parentCategoryID: Int
        }
        struct Response
        {
            var listItem: ListItemModel?
            var error: String?
        }
        struct ViewModel
        {
            var listItem: ListItemModel?
            var error: String?
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
        }
        struct ViewModel
        {
            var error: String?
        }
    }
}
