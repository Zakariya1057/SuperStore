//
//  HomeObject.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 11/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class HomeObject: Object {
    
    @objc dynamic var storeTypeID: Int = 0
    
    var lists = List<ListObject>()
    var stores = List<StoreObject>()
    
    var featured = List<ProductObject>()
    var groceries = List<ProductObject>()
    var monitoring = List<ProductObject>()
    
    var promotions = List<PromotionObject>()
    
    var categories = List<ChildCategoryObject>()
}
