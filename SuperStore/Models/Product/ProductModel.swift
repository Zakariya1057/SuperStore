//
//  ProductModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ProductModel {
    var id: Int
    var name: String
    var companyID: Int
    
    var price: ProductPriceModel?

    var currency: String
    
    var smallImage: String?
    var largeImage: String?
    
    var images: [ImageModel]
    
    var description: String?
    var features: [String]?
    var dimensions: [String]?

    var favourite: Bool
    var monitoring: Bool

    var quantity: Int = 0
    var avgRating: Double = 0
    var totalReviewsCount: Int = 0

    var parentCategoryID: Int?
    var parentCategoryName: String?

    var childCategoryID: Int?
    var childCategoryName: String?
    
    var productGroupName: String?

    var storage: String?
    var weight: String? = nil
    var brand: String?

    var dietaryInfo: String?
    var allergenInfo: String?

    var reviews: [ReviewModel] = []

    var ingredients: [String] = []
    
    var nutritions: [NutritionModel] = []

    var recommended: [ProductModel] = []

    var listID: Int? = nil
    
    init(
        id: Int,
        companyID: Int,
        name: String,
        
        smallImage: String?,
        largeImage: String?,
        images: [ImageModel],
        
        brand: String?,
        description: String?,
        
        features: [String]?,
        dimensions: [String]?,
        
        price: ProductPriceModel?,
        
        currency: String,
        
        avgRating: Double?,
        totalReviewsCount: Int?,
        reviews: [ReviewModel],
        
        storage: String?,
        weight: String?,
        
        parentCategoryID: Int?,
        parentCategoryName: String?,
        childCategoryID: Int?,
        childCategoryName: String?,
        productGroupName: String?,
        
        dietaryInfo: String?,
        allergenInfo: String?,
        
        favourite: Bool,
        monitoring: Bool,
        
        ingredients: [String],
        nutritions: [NutritionModel],
        
        recommended: [ProductModel]
    ) {

        self.id = id
        self.companyID = companyID
        self.description = description
        self.features = features
        self.dimensions = dimensions
        
        self.favourite = favourite
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.monitoring = monitoring

        self.parentCategoryID = parentCategoryID
        self.parentCategoryName = parentCategoryName
        
        self.childCategoryID = childCategoryID
        self.childCategoryName = childCategoryName
        
        self.productGroupName = productGroupName

        self.weight = weight
        
        self.storage = storage
        self.avgRating = avgRating ?? 0
        self.totalReviewsCount = totalReviewsCount ?? 0
        self.dietaryInfo = dietaryInfo
        self.allergenInfo = allergenInfo
        self.brand = brand
        self.reviews = reviews
        self.favourite = favourite
        self.ingredients = ingredients
        self.recommended = recommended
        
        self.name = name
        
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.images = images
        
        self.price = price
        self.currency = currency
        
        self.nutritions = nutritions
    }

}

extension ProductModel: Equatable  {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ProductModel  {
    func getPrice() -> String {
        return currency + String(format: "%.2f", price!.price)
    }
    
    func getOldPrice() -> String? {
        return price!.oldPrice == nil ? nil : currency + String(format: "%.2f", price!.oldPrice!)
    }
}
