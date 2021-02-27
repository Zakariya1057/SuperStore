//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealmStore: UserStoreProtocol {
    let realm = try? Realm()
    
    var user: User? {
        return realm?.objects(User.self).first
    }
    
    func saveLoggedInUser(user: UserLoginModel){
        // Delete all data including, user details and user lists
        deleteAllData()
        
        try? realm?.write({
            let savedUser = User()
            savedUser.name = user.name
            savedUser.email = user.email
            savedUser.token = user.token
            savedUser.id = user.id
            savedUser.sendNotifications = user.send_notifications
            realm?.add(savedUser)
        })
    }
    
    func deleteAllData(){
        try? realm?.write({
            realm?.deleteAll()
        })
    }
    
    func retrieveToken() -> String? {
        user?.token
    }
}
