//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealmStore: DataStore, UserStoreProtocol {
    
    private lazy var storeTypeWorker: StoreTypeWorker = StoreTypeWorker()
    private lazy var regionWorker: RegionWorker = RegionWorker()
    
    private var user: UserObject? {
        return realm?.objects(UserObject.self).first
    }
    
    func createUser(user: UserModel) {
        deleteUser()
        
        try? realm?.write({
            let savedUser = UserObject()
            savedUser.name = user.name
            savedUser.email = user.email
            savedUser.token = user.token
            savedUser.storeTypeID = user.storeTypeID
            savedUser.regionID = user.regionID
            savedUser.id = user.id
            savedUser.sendNotifications = user.sendNotifications
            realm?.add(savedUser)
        })
    }
    
    func getUser() -> UserModel? {
        // If no user found, then create a empty one.
        if let savedUser = user {
            return savedUser.getUserModel()
        } else {
            return createEmptyUser()?.getUserModel()
        }
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
    
    func updateRegion(regionID: Int){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.regionID = regionID
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
        deleteAllData()
    }
    
    func deleteUser() {
        deleteAllData()
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
        return user?.token == "" ? nil : user?.token
    }
    
    func getRegionID() -> Int? {
        return user?.regionID
    }
    
    func getStoreID() -> Int? {
        return user?.storeTypeID
    }
    
    func getUserID() -> Int? {
        return user?.id
    }
}

extension UserRealmStore {
    func createEmptyUser() -> UserObject? {
        let savedUser = UserObject()
        
        savedUser.storeTypeID = storeTypeWorker.getSelectedStoreType().id
        savedUser.regionID = regionWorker.getSelectedRegion().id
        
        try? realm?.write({
            realm?.add(savedUser)
        })
        
        return savedUser
    }
}
