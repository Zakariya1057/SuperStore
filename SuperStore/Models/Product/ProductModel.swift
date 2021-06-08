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
    var storeTypeID: Int
    
    var promotion: PromotionModel?
    
    var price: Double
    var oldPrice: Double?
    var isOnSale: Bool?
    var saleEndsAt: Date?

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

    var recommended: [ProductModel] = []

    var listID: Int? = nil
    
    init(
        id: Int, storeTypeID: Int, name: String,
        smallImage: String?, largeImage: String?,
        images: [ImageModel], description: String?, features: [String]?,
        dimensions: [String]?,
        price:Double, oldPrice: Double?, isOnSale: Bool?, saleEndsAt: Date?,
        currency: String,
        avgRating: Double?, totalReviewsCount: Int?,
        promotion: PromotionModel?, storage: String?,
        weight: String?,
        
        parentCategoryID: Int?, parentCategoryName: String?,
        childCategoryID: Int?, childCategoryName: String?,
        productGroupName: String?,
        
        dietaryInfo: String?,
        allergenInfo: String?, brand: String?, reviews: [ReviewModel],
        favourite: Bool, monitoring: Bool, ingredients: [String],
        recommended: [ProductModel]
    ) {

        self.id = id
        self.storeTypeID = storeTypeID
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
        
        let dateWorker = DateWorker()
        
        setPromotion(dateWorker: dateWorker, promotion: promotion)
        setSalePrices(dateWorker: dateWorker, oldPrice: oldPrice, isOnSale: isOnSale, saleEndsAt: saleEndsAt)
    }
    
    
    private func setPromotion(dateWorker: DateWorker, promotion: PromotionModel?){
        if let promotion = promotion {
            if let endsAt = promotion.endsAt {
                if dateWorker.dateDiff(date: endsAt) >= 0 {
                    self.promotion = promotion
                }
            } else {
                self.promotion = promotion
            }
        }
    }
    
    private func setSalePrices(dateWorker: DateWorker, oldPrice: Double?, isOnSale: Bool?, saleEndsAt: Date?){
        // On model creation, check if sale, promotion expired. If has, then never set in the model.
        self.saleEndsAt = saleEndsAt
        
        if let saleEndsAt = saleEndsAt, let oldPrice = oldPrice {
            if dateWorker.dateDiff(date: saleEndsAt) < 0 {
                self.price = oldPrice
                self.isOnSale = false
                self.oldPrice = nil
            } else {
                self.oldPrice = oldPrice
                self.isOnSale = isOnSale
            }
        } else {
            self.oldPrice = oldPrice
            self.isOnSale = isOnSale
        }
    }

}

extension ProductModel: Equatable  {
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ProductModel  {
    func getPrice() -> String {
        return currency + String(format: "%.2f", price)
    }
    
    func getOldPrice() -> String? {
        return oldPrice == nil ? nil : currency + String(format: "%.2f", oldPrice!)
    }
}
