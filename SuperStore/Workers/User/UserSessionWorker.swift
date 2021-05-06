//
//  UserSessionWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserSessionWorker {
    
    static var online: Bool = false
    static var notificationToken: String?
    
    private var networkManager: NetworkWorker = NetworkWorker()
    private var userStore: UserStoreProtocol = UserRealmStore()
    
    func getUserToken() -> String? {
        return userStore.getToken()
    }
    
    func getUserID() -> Int? {
        return userStore.getUserID()
    }
    
    func getStore() -> Int {
        return userStore.getStore() ?? 2
    }
    
    func getUserNotificationToken() -> String? {
        return type(of: self).notificationToken
    }
    
    func logInUser(user: UserModel){
        userStore.createUser(user: user)
    }
    
    func logOutUser(){
        userStore.logoutUser()
    }
    
    
    func isLoggedIn() -> Bool {
        return getUserToken() != nil
    }
    
    func isOnline() -> Bool {
        return type(of: self).online
    }
}
