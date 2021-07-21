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
    
    private lazy var supermarketChainWorker: SupermarketChainWorker = SupermarketChainWorker()
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
            savedUser.supermarketChainID = user.supermarketChainID
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
    
    func updateStore(supermarketChainID: Int){
        try? realm?.write({
            if let savedUser: UserObject = self.user {
                savedUser.supermarketChainID = supermarketChainID
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
    
    func getSupermarketChainID() -> Int? {
        return user?.supermarketChainID
    }
    
    func getUserID() -> Int? {
        return user?.id
    }
}

extension UserRealmStore {
    func createEmptyUser() -> UserObject? {
        let savedUser = UserObject()
        
        savedUser.supermarketChainID = supermarketChainWorker.getSelectedSupermarketChain().id
        savedUser.regionID = regionWorker.getSelectedRegion().id
        
        try? realm?.write({
            realm?.add(savedUser)
        })
        
        return savedUser
    }
}

extension UserRealmStore {
    func supermarketChainChangeRequired(regionID: Int, supermarketChainID: Int) -> Bool {
        // If the selected supermarket chain isn't available for the region
        // Change to another supermarket chain
        let region = regionWorker.getRegion(regionID: regionID)
        return !region!.supermarketChains.contains(where: { $0.id == supermarketChainID })
    }
}
