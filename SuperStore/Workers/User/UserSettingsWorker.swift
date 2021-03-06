//
//  UserWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserSettingsWorker {
    var userStore: UserStoreProtocol
    var userAPI: UserRequestProtocol
    
    init(userStore: UserStoreProtocol) {
        self.userStore = userStore
        self.userAPI = UserSettingAPI()
    }
    
    func getUser(completionHandler: @escaping (_ user: UserModel?) -> Void){
        completionHandler(userStore.getUser())
    }
    
    func updateNotifications(sendNotifications: Bool, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updateNotifications(sendNotifications: sendNotifications, completionHandler: { (error: String?) in
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
    
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.updatePassword(
            currentPassword: currentPassword, newPassword: newPassword,
            confirmPassword: confirmPassword, completionHandler: completionHandler
        )
    }
}

extension UserSettingsWorker {
    func logout(completionHandler: @escaping (_ error: String?) -> Void){
        userAPI.logout(completionHandler: completionHandler)
        userStore.logoutUser()
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
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (_ error: String?) -> Void)
    func updateName(name: String, completionHandler: @escaping (_ error: String?) -> Void)
    func updateEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void)
    func updateNotifications(sendNotifications: Bool, completionHandler: @escaping (_ error: String?) -> Void)
    
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
    
    func logoutUser() -> Void
    func deleteUser() -> Void
    
    func getToken() -> String?
}
