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
    @objc dynamic var productID: Int = 1
    @objc dynamic var userID: Int = 1
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var createdAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getReviewModel () -> ReviewModel {

        return ReviewModel(id: self.id, text: self.text, title: self.title, rating: self.rating, name: self.name, productID: self.productID, userID: self.userID, updatedAt: self.updatedAt, createdAt: self.createdAt)
    }
    
}
