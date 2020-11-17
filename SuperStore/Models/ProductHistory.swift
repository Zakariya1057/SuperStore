//
//  SearchRealmModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductHistory: Object {
    
    @objc dynamic var id: Int = 1
    @objc dynamic var name:String = ""
    
    @objc dynamic var smallImage: String = ""
    @objc dynamic var largeImage: String = ""
    
    @objc dynamic var productDescription: String? = nil
    @objc dynamic var price:Double = 0
    
    @objc dynamic var avgRating: Double = 0
    @objc dynamic var totalReviewsCount: Int = 0
    @objc dynamic var quantity: Int = 0
    @objc dynamic var weight: String? = ""
    
    @objc dynamic var parentCategoryId: Int = 1
    @objc dynamic var parentCategoryName: String? = nil
    @objc dynamic var childCategoryName: String? = nil
    
    @objc dynamic var storage: String?
    
    @objc dynamic var dietaryInfo: String? = nil
    @objc dynamic var allergenInfo: String? = nil
    
    @objc dynamic var brand:String = ""
    
    var reviews = List<ReviewHistory>()
    
    var ingredients = List<String>()
    
    var recommended = List<Int>()
    
    @objc dynamic var favourite: Bool = false
    @objc dynamic var monitoring: Bool = false
    
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    @objc dynamic var promotion: PromotionHistory? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name","parentCategoryId"]
    }
    
    func getProductModel() -> ProductModel {

        return ProductModel(
            id: self.id, name: self.name, smallImage: self.smallImage, largeImage: self.largeImage,
            description: self.productDescription, quantity: self.quantity,
            price: self.price,avgRating: self.avgRating,
            totalReviewsCount: self.totalReviewsCount,
            promotion: self.promotion?.getPromotionModel(), storage: self.storage,
            weight: self.weight, parentCategoryId: self.parentCategoryId,
            parentCategoryName: self.parentCategoryName, childCategoryName: self.childCategoryName,
            dietaryInfo: self.dietaryInfo, allergenInfo: self.allergenInfo,
            brand: self.brand, reviews: self.reviews.map {$0.getReviewModel()} , favourite: self.favourite, monitoring: self.monitoring,
            ingredients:self.ingredients.map { "\($0)"} , recommended: [])

    }
}
