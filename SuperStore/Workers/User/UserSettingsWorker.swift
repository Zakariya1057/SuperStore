//
//  UserWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserSettingsWorker {
    private var userStore: UserStoreProtocol
    private var userAPI: UserRequestProtocol
    
    private lazy var regionWorker: RegionWorker = RegionWorker()
    
    init(userStore: UserStoreProtocol) {
        self.userStore = userStore
        self.userAPI = UserSettingAPI()
    }
    
    func getUser(completionHandler: @escaping (_ user: UserModel?) -> Void){
        completionHandler(userStore.getUser())
    }
    
    func updateNotifications(sendNotifications: Bool, notificationToken: String?, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updateNotifications(sendNotifications: sendNotifications, notificationToken: notificationToken, completionHandler: { (error: String?) in
            if error == nil {
                self.userStore.updateNotifications(sendNotifications: sendNotifications)
            }
            completionHandler(error)
        })
    }
    
    func updateName(name: String, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updateName(name: name, completionHandler: { (error: String?) in
            if error == nil {
                self.userStore.updateName(name: name)
            }
            completionHandler(error)
        })
    }
    
    func updateEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updateEmail(email: email, completionHandler: { (error: String?) in
            if error == nil {
                self.userStore.updateEmail(email: email)
            }
            
            completionHandler(error)
        })
    }
    
    func updateRegion(regionID: Int, loggedIn: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        
        self.userStore.updateRegion(regionID: regionID)
        
        if loggedIn {
            userAPI.updateRegion(regionID: regionID, completionHandler: { (error: String?) in
                completionHandler(error)
            })
            
            // If the selected region doesn't have the selected supermarket chain, use another one
//            if let supermarketChainID = userStore.getSupermarketChainID() {
//                if userStore.supermarketChainChangeRequired(regionID: regionID, supermarketChainID: supermarketChainID ){
//                    let supermarketChainID = regionWorker.getRegionSupermarketChainID(regionID: regionID)
//                    self.updateStore(supermarketChainID: supermarketChainID, loggedIn: loggedIn) { _ in }
//                }
//            }
    
        } else {
            completionHandler(nil)
        }
    }
    
    func updateStore(supermarketChainID: Int, loggedIn: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        self.userStore.updateStore(supermarketChainID: supermarketChainID)
        
        if loggedIn {
            userAPI.updateStore(supermarketChainID: supermarketChainID, completionHandler: { (error: String?) in
                completionHandler(error)
            })
        } else {
            completionHandler(nil)
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updatePassword(
            currentPassword: currentPassword, newPassword: newPassword,
            confirmPassword: confirmPassword, completionHandler: completionHandler
        )
    }
}

extension UserSettingsWorker {
    func updateNewUserRegionID(regionID: Int){
        // For first time new users, use closest store to update default region id
        if !userStore.defaultRegionChanged(){
            self.userStore.updateRegion(regionID: regionID)
        }
    }
}

extension UserSettingsWorker {
    func logout(completionHandler: @escaping (_ error: String?) -> Void){
        
        userAPI.logout { (error: String?) in
            if let error = error {
                print(error)
            }
            completionHandler(nil)
        }
        
        self.userStore.logoutUser()
    }
    
    func deleteUser(completionHandler: @escaping (_ error: String?) -> Void){
        // Only delete user if successfully deleted
        userAPI.deleteUser(completionHandler: { (error: String?) in
            if error == nil {
                self.userStore.deleteUser()
            }
            
            completionHandler(error)
        })
    }
}

// API
protocol UserRequestProtocol {
    func updateName(name: String, completionHandler: @escaping (_ error: String?) -> Void)
    func updateEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void)
    
    func updateRegion(regionID: Int, completionHandler: @escaping (_ error: String?) -> Void)
    func updateStore(supermarketChainID: Int, completionHandler: @escaping (_ error: String?) -> Void)
    
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (_ error: String?) -> Void)
    func updateNotifications(sendNotifications: Bool, notificationToken: String?, completionHandler: @escaping (_ error: String?) -> Void)
    
    func logout(completionHandler: @escaping (_ error: String?) -> Void)
    func deleteUser(completionHandler: @escaping (_ error: String?) -> Void)
}

// Realm
protocol UserStoreProtocol {
    func createUser(user: UserModel) -> Void
    func getUser() -> UserModel?
    
    func updateNotifications(sendNotifications: Bool)
    
    func updateName(name: String) -> Void
    func updateEmail(email: String) -> Void
    
    func updateRegion(regionID: Int) -> Void
    func updateStore(supermarketChainID: Int) -> Void
    
    func defaultRegionChanged() -> Bool
//    func supermarketChainChangeRequired(regionID: Int, supermarketChainID: Int) -> Bool
    
    func logoutUser() -> Void
    func deleteUser() -> Void
    
    func getToken() -> String?
    func getUserID() -> Int?
    
    func getSupermarketChainID() -> Int?
    func getRegionID() -> Int?
}
