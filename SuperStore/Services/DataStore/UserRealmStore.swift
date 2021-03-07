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
            savedUser.storeTypeID = user.storeTypeID
            savedUser.id = user.id
            savedUser.sendNotifications = user.sendNotifications
            realm?.add(savedUser)
        })
    }
    
    func getUser() -> UserModel? {
        return user?.getUserModel()
    }
    
    func updateName(name: String){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.name = name
            }
        })
    }
    
    func updateEmail(email: String){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.email = email
            }
        })
    }
    
    func updateStore(storeTypeID: Int){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.storeTypeID = storeTypeID
            }
        })
    }
    
    
    func updateNotifications(sendNotifications: Bool){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.sendNotifications = sendNotifications
            }
        })
    }
    
    func logoutUser(){
        deleteUser()
    }
    
    func deleteUser() {
        try? realm?.write({
            if let users = realm?.objects(UserObject.self) {
                realm?.delete(users)
            }
        })
    }
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
    
    func getStore() -> Int? {
        return user?.storeTypeID
    }
}
