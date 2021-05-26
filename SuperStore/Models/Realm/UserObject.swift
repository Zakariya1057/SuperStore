//
//  UserHistory.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @objc dynamic var id: Int = 1
    
    @objc dynamic var name: String = ""
    @objc dynamic var token: String = ""
    @objc dynamic var email: String = ""
    
    @objc dynamic var regionID: Int = 1
    @objc dynamic var storeTypeID: Int = 2

    @objc dynamic var sendNotifications: Bool = true
    
    func getUserModel() -> UserModel {
        return UserModel(id: id, name: name, token: token, email: email, regionID: regionID, storeTypeID: storeTypeID, sendNotifications: sendNotifications)
    }
}
