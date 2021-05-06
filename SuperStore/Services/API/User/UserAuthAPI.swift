//
//  UserAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class UserAuthAPI: API, UserAuthProtocol {

    func login(
        email: String,
        password: String,
        notificationToken: String?,
        completionHandler: @escaping (UserModel?, String?) -> Void
    ) {
        
        let registerData: Parameters = [
            "email": email,
            "password": password,
            "notification_token": notificationToken ?? ""
        ]
        
        requestWorker.post(url: Config.Route.User.Login, data: registerData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let userDataResponse =  try self.jsonDecoder.decode(UserDataResponse.self, from: data)
                let user = self.createUserLogin(userDataResponse: userDataResponse)
                
                completionHandler(user, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                print(error)
                completionHandler(nil, "Login Failed. Decoding error, please try again later.")
            }
        }
    }
    
    func register(
        name: String,
        email: String,
        storeTypeID: Int,
        password: String,
        passwordConfirmation: String,
        notificationToken: String? = "",
        identifier: String? = nil,
        userToken: String? = nil,
        completionHandler: @escaping (UserModel?, String?) -> Void
    ) {
        
        let registerData: Parameters = [
            "name": name,
            "email": email,
            "store_type_id": storeTypeID,
            "password": password,
            "password_confirmation": passwordConfirmation,
            "notification_token": notificationToken ?? "",
            "identifier": identifier ?? "",
            "user_token": userToken ?? ""
        ]
        
        requestWorker.post(url: Config.Route.User.Register, data: registerData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let userDataResponse =  try self.jsonDecoder.decode(UserDataResponse.self, from: data)
                let user = self.createUserLogin(userDataResponse: userDataResponse)
                
                completionHandler(user, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                completionHandler(nil, "Registration Failed. Please try again later.")
            }
        }
    }
    
}

extension UserAuthAPI {
    private func createUserLogin(userDataResponse: UserDataResponse) -> UserModel? {
        let userData = userDataResponse.data
        
        return UserModel(
            id: userData.id,
            name: userData.name,
            token: userData.token,
            email: userData.email,
            storeTypeID: userData.store_type_id,
            sendNotifications: userData.send_notifications
        )
    }
}
