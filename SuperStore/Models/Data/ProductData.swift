//
//  ProductData.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

struct ProductDataResponse: Decodable {
    var data: ProductData
}

struct ProductsDataResponse: Decodable {
    var data: [ProductData]
}

struct ProductData:Decodable {
    var id: Int
    var name:String

    var small_image: String?
    var large_image: String?
    
    var images: [ImageData]?
    
    var store_type_id: Int
    
    var description: String?
    var features: [String]?
    var dimensions: [String]?
    
    var price: Double
    var old_price: Double?
    var is_on_sale: Bool?
    var sale_ends_at: String?
    
    var currency: String
    
    var storage: String?
    var weight: String?
    
    var avg_rating: Double?
    var total_reviews_count: Int?
    
    var dietary_info: String?
    var allergen_info: String?
    
    var brand:String?
    var favourite: Bool?
    var monitoring: Bool?
    
    var reviews: [ReviewData]?
    var ingredients: [IngredientsData]?
    
    var recommended: [ProductData]?
    
    var parent_category_id: Int?
    var parent_category_name: String?
    
    var child_category_id: Int?
    var child_category_name: String?
    
    var product_group_name: String?
    
    var promotion: PromotionData?
    
    func getProductModel() -> ProductModel {
        let dateWorker = DateWorker()
        
        return ProductModel(
            id: id,
            storeTypeID: store_type_id,
            name: name,
            smallImage: small_image,
            largeImage: large_image,
            images: images?.map({ $0.getImageModel() }) ?? [],
            description: description,
            features: features,
            dimensions: dimensions,
            price: price,
            oldPrice: old_price,
            isOnSale: is_on_sale,
            saleEndsAt: sale_ends_at == nil ? nil : dateWorker.formatDate(date: sale_ends_at!),
            currency: currency,
            avgRating: avg_rating,
            totalReviewsCount: total_reviews_count,
            promotion: promotion?.getPromotionModel(),
            storage: storage,
            weight: weight,
            
            parentCategoryID: parent_category_id, parentCategoryName: parent_category_name,
            childCategoryID: child_category_id, childCategoryName: child_category_name,
            productGroupName: product_group_name,
            
            dietaryInfo: dietary_info,
            allergenInfo: allergen_info,
            brand: brand,
            
            reviews: reviews?.map({ (review: ReviewData) in
                return review.getReviewModel()
            }) ?? [],
            
            favourite: favourite ?? false,
            monitoring: monitoring ?? false,
            
            ingredients: ingredients?.map({ (ingredient: IngredientsData) in
                return ingredient.name
            }) ?? [],
            
            recommended: recommended?.map({ (product: ProductData) in
                return product.getProductModel()
            }) ?? []
        )
    }
}

struct IngredientsData: Decodable {
    var name: String
}
