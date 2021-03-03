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
    
    private let realm = try? Realm()
    
    private var user: UserObject? {
        return realm?.objects(UserObject.self).first
    }
    
    func createUser(user: UserModel) {
        try? realm?.write({
            let savedUser = UserObject()
            savedUser.name = user.name
            savedUser.email = user.email
            savedUser.token = user.token
            savedUser.id = user.id
            savedUser.sendNotifications = user.sendNotifications
            realm?.add(savedUser)
        })
    }
    
    func getUser() -> UserModel? {
        return user?.getUserModel()
    }
    
    func updateUser(user: UserModel) {
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.name = user.name
                savedUser.email = user.email
            }
        })
    }
    
    func deleteUser(user: UserModel) {
        try? realm?.write({
            if let users = realm?.objects(UserObject.self) {
                realm?.delete(users)
            }
        })
    }

    
    //    private let realm = try? Realm()
    //
    //    private var user: UserObject? {
    //        return realm?.objects(UserObject.self).first
    //    }
    //
    //    // Create
    //    func createUser(user: UserModel){
    //
    //    }
    //
    //    // Read
    //    func getUser() -> UserModel {
    //
    //    }
    //
    //    // Update
    //    func updateUser(user: UserModel){
    //
    //    }
    //
    //    // Delete
    //    func deleteUser(user: UserModel){
    //
    //    }
    //
    //    func saveLoggedInUser(user: UserLoginModel){
    //        // Delete all data including, user details and user lists
    //        deleteAllData()
    //
    //        try? realm?.write({
    //            let savedUser = UserObject()
    //            savedUser.name = user.name
    //            savedUser.email = user.email
    //            savedUser.token = user.token
    //            savedUser.id = user.id
    //            savedUser.sendNotifications = user.send_notifications
    //            realm?.add(savedUser)
    //        })
    //    }
    //
    //    func deleteAllData(){
    //        try? realm?.write({
    //            realm?.deleteAll()
    //        })
    //    }
    //
    //    func getUser() -> UserObject? {
    //        return user
    //    }
    
}

extension UserRealmStore {
    func deleteAllData(){
        try? realm?.write({
            realm?.deleteAll()
        })
    }
}


extension UserRealmStore {
    func getToken() -> String? {
        return user?.token
    }
}
