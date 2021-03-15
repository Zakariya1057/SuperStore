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
    @objc dynamic var currency: String = ""
    
    @objc dynamic var smallImage: String = ""
    @objc dynamic var largeImage: String = ""
    
    var images = List<ImageObject>()
    
    var promotion: PromotionObject? = nil
    
    var productDescription: String? = nil
    var features = List<String>()
    var dimensions = List<String>()

    @objc dynamic var favourite: Bool = false
    @objc dynamic var monitoring: Bool = false

    @objc dynamic var quantity: Int = 0
    @objc dynamic var avgRating: Double = 0
    @objc dynamic var totalReviewsCount: Int = 0

    var parentCategoryID = RealmOptional<Int>()
    
    @objc dynamic var parentCategoryName: String? = nil
    @objc dynamic var childCategoryName: String? = nil

    var storage: String? = nil
    var weight: String? = nil
    var brand: String? = nil

    @objc dynamic var dietaryInfo: String? = nil
    @objc dynamic var allergenInfo: String? = nil

    var reviews = List<ReviewObject>()

    var ingredients = List<String>()

    var recommended = List<ProductObject>()
    
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
            currency: currency,
            avgRating: avgRating,
            totalReviewsCount: totalReviewsCount,
            promotion: promotion?.getPromotionModel(),
            storage: storage,
            weight: weight,
            parentCategoryID: parentCategoryID.value,
            parentCategoryName: parentCategoryName,
            childCategoryName: childCategoryName,
            dietaryInfo: dietaryInfo,
            allergenInfo: allergenInfo,
            brand: brand,
            reviews: reviews.map{ $0.getReviewModel() },
            favourite: favourite,
            monitoring: monitoring,
            ingredients: ingredients.map{ String($0) },
            recommended: recommended.map({ $0.getProductModel() })
        )
    }
}
