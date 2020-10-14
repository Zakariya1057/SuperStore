//
//  SearchRealmModel.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 10/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ReviewHistory: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var rating: Int = 1
    @objc dynamic var product_id: Int = 1
    @objc dynamic var user_id: Int = 1
    @objc dynamic var updated_at: Date = Date()
    @objc dynamic var created_at: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getReviewModel () -> ReviewModel {

        return ReviewModel(id: self.id, text: self.text, title: self.title, rating: self.rating, name: self.name, product_id: self.product_id, user_id: self.user_id, updated_at: self.updated_at, created_at: self.created_at)
    }
    
}
