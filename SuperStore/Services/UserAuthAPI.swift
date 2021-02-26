//
//  UserAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

struct UserAuthAPI: UserAuthProtocol {

    let jsonDecoder = JSONDecoder()
    
    let requestWorker: RequestProtocol = RequestWorker()

    func login(email: String, password: String, notificationToken: String?, completionHandler: @escaping (UserLoginModel?, String?) -> Void) {
        
        let registerData: Parameters = [
            "email": email,
            "password": password,
            "notification_token": notificationToken ?? ""
        ]
        
        requestWorker.post(url:"http://192.168.1.187/api/user/login", data: registerData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let userResponseData =  try? jsonDecoder.decode(UserDataResponse.self, from: data)
                let user = createUserLogin(userResponseData: userResponseData)
                
                completionHandler(user, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                completionHandler(nil, "Login Failed. Please try again later.")
            }
        }
    }
    
    func register(name: String, email: String, password: String, passwordConfirmation: String, notificationToken: String? = "",  identifier: String? = nil, userToken: String? = nil, completionHandler: @escaping (UserLoginModel?, String?) -> Void) {
        
        let registerData: Parameters = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirmation,
            "notification_token": notificationToken ?? "",
            "identifier": identifier ?? "",
            "user_token": userToken ?? ""
        ]
        
        requestWorker.post(url:"http://192.168.1.187/api/user/register", data: registerData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let userResponseData =  try? jsonDecoder.decode(UserDataResponse.self, from: data)
                let user = createUserLogin(userResponseData: userResponseData)
                
                completionHandler(user, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                completionHandler(nil, "Login Failed. Please try again later.")
            }
        }
    }
    
}

extension UserAuthAPI {
    private func createUserLogin(userResponseData: UserDataResponse?) -> UserLoginModel? {
        
        if let userResponseData = userResponseData {
            let userData = userResponseData.data
            
            return UserLoginModel(
                id: userData.id,
                name: userData.name,
                token: userData.token,
                email: userData.email,
                send_notifications: userData.send_notifications
            )
        }
        
        return nil
    }
}
