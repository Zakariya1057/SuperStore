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
    
    func updateName(name: String, completionHandler: @escaping (_ error: String?) -> Void){
        userStore.updateName(name: name)
        userAPI.updateUser(data: ["name" : name], type: "name", completionHandler: completionHandler)
    }
    
    func updateEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void){
        userStore.updateEmail(email: email)
        userAPI.updateUser(data: ["email" : email], type: "email", completionHandler: completionHandler)
    }
    
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (_ error: String?) -> Void){
        let updateData = [
            "current_password": currentPassword,
            "password": newPassword,
            "password_confirmation": confirmPassword
        ]
        
        userAPI.updateUser(data: updateData, type: "password", completionHandler: completionHandler)
    }
}

// When update done, do on both the local and remote.

// Update details by API
protocol UserRequestProtocol {
    func updateUser(data: [String:String],type: String, completionHandler: @escaping (_ error: String?) -> Void)
}

// Update details by REALM
protocol UserStoreProtocol {
    func createUser(user: UserModel) -> Void
    func getUser() -> UserModel?
    
    func updateName(name: String)
    func updateEmail(email: String)
    
    func deleteUser(user: UserModel) -> Void
    
    func getToken() -> String?
}
