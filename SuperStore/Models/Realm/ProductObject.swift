//
//  ProductObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductObject: Object {
    
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    
    @objc dynamic var storeTypeID: Int = 0
    
    @objc dynamic var price: Double = 0
    var oldPrice =  RealmOptional<Double>()
    var isOnSale =  RealmOptional<Bool>()
    
    @objc dynamic var saleEndsAt: Date? = nil
    
    @objc dynamic var currency: String = ""
    
    @objc dynamic var smallImage: String? = nil
    @objc dynamic var largeImage: String? = nil
    
    var images = List<ImageObject>()
    
    @objc dynamic var promotion: PromotionObject? = nil
    
    var promotionID = RealmOptional<Int>()
    
    @objc dynamic var productDescription: String? = nil
    var features = List<String>()
    var dimensions = List<String>()

    @objc dynamic var favourite: Bool = false
    @objc dynamic var monitoring: Bool = false

    @objc dynamic var quantity: Int = 0
    @objc dynamic var avgRating: Double = 0
    @objc dynamic var totalReviewsCount: Int = 0

    var parentCategoryID = RealmOptional<Int>()
    @objc dynamic var parentCategoryName: String? = nil
    
    var childCategoryID = RealmOptional<Int>()
    @objc dynamic var childCategoryName: String? = nil
    
    @objc dynamic var productGroupName: String? = nil

    @objc dynamic var storage: String? = nil
    @objc dynamic var weight: String? = nil
    @objc dynamic var brand: String? = nil

    @objc dynamic var dietaryInfo: String? = nil
    @objc dynamic var allergenInfo: String? = nil

    var reviews = List<ReviewObject>()

    var ingredients = List<String>()

    var recommended = List<ProductObject>()
    
    @objc dynamic var enabled: Bool = true
    
    @objc dynamic var monitoredUpdatedAt: Date = Date()
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    func getProductModel() -> ProductModel {
        var productFeatures: [String]? = nil
        var productDimensions: [String]? = nil
        
        if(features.count > 0){
            productFeatures = features.map{ String($0) }
        }
        
        if(dimensions.count > 0){
            productDimensions = dimensions.map{ String($0) }
        }

        return ProductModel(
            id: id,
            storeTypeID: storeTypeID,
            name: name,
            smallImage: smallImage,
            largeImage: largeImage,
            images: images.map{ $0.getImageModel() },
            description: productDescription,
            features: productFeatures,
            dimensions: productDimensions,
            price: price,
            oldPrice: oldPrice.value,
            isOnSale: isOnSale.value,
            saleEndsAt: saleEndsAt,
            currency: currency,
            avgRating: avgRating,
            totalReviewsCount: totalReviewsCount,
            promotion: nil,
            storage: storage,
            weight: weight,
            
            parentCategoryID: parentCategoryID.value, parentCategoryName: parentCategoryName,
            childCategoryID: childCategoryID.value, childCategoryName: childCategoryName,
            
            productGroupName: productGroupName,
            
            dietaryInfo: dietaryInfo,
            allergenInfo: allergenInfo,
            brand: brand,
            reviews: reviews.map{ $0.getReviewModel() },
            favourite: favourite,
            monitoring: monitoring,
            ingredients: ingredients.map{ String($0) },
            recommended: []
        )
    }
    
    
    override static func primaryKey() -> String? {
         return "id"
    }
}
