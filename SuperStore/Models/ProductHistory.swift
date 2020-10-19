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
    @objc dynamic var image: String = ""
    @objc dynamic var product_description: String? = ""
    @objc dynamic var price:Double = 0
    
    @objc dynamic var avg_rating: Double = 0
    @objc dynamic var total_reviews_count: Int = 0
    @objc dynamic var quantity: Int = 1
    @objc dynamic var weight: String? = ""
    
    @objc dynamic var parent_category_id: Int = 1
    @objc dynamic var parent_category_name: String? = ""
    
    @objc dynamic var storage: String?
    
    @objc dynamic var dietary_info: String?
    @objc dynamic var allergen_info: String?
    
    @objc dynamic var brand:String = ""
    
    var reviews = List<ReviewHistory>()
    
    var ingredients = List<String>()
    
    var recommended = List<Int>()
    
    @objc dynamic var favourite: Bool = false
    
    @objc dynamic var updated_at: Date = Date()
    @objc dynamic var created_at: Date = Date()
    
    @objc dynamic var promotion: PromotionHistory? = nil
    
    override static func indexedProperties() -> [String] {
        return ["id", "name","parent_category_id"]
    }
    
    func getProductModel() -> ProductDetailsModel {
        
        return ProductDetailsModel(
            id: self.id, name: self.name, image: self.image,
            description: self.product_description, quantity: self.quantity,
            price: self.price,avg_rating: self.avg_rating,
            total_reviews_count: self.total_reviews_count,
            promotion: self.promotion?.getPromotionModel(), storage: self.storage,
            weight: self.weight, parent_category_id: self.parent_category_id,
            parent_category_name: self.parent_category_name,
            dietary_info: self.dietary_info, allergen_info: self.allergen_info,
            brand: self.brand, reviews: self.reviews.map {$0.getReviewModel()} , favourite: self.favourite,
            ingredients:self.ingredients.map { "\($0)"} , recommended: [])
    }
}
