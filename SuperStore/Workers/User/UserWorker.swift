//
//  UserWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class UserWorker {
    var userStore: UserStoreProtocol
    
    init(userStore: UserStoreProtocol) {
        self.userStore = userStore
    }
    
    func getUser(completionHandler: @escaping (_ user: UserModel?) -> Void ){
        completionHandler(userStore.getUser())
    }
    
    func updateUser(){
        
    }
//    func sendEmail(email: String, completionHandler: @escaping (_ error: String?) -> Void ){
//        passwordReset.sendEmail(email: email, completionHandler: completionHandler)
//    }
}

// When update done, do on both the local and remote.

// Update details by API
protocol UserRequestProtocol {

}

// Update details by REALM
protocol UserStoreProtocol {
    func createUser(user: UserModel) -> Void
    func getUser() -> UserModel?
    func updateUser(user: UserModel) -> Void
    func deleteUser(user: UserModel) -> Void
    
    func getToken() -> String?
}
