//
//  ResetPasswordAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class ResetPasswordAPI: API, ResetPasswordProtocol {
    
    func sendEmail(email: String, completionHandler: @escaping (String?) -> Void) {
        
        requestWorker.post(url: Config.Routes.User.ResetPassword.SendEmail, data: ["email": email]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Reset Failed. Decoding error, please try again later.")
            }
        }
        
    }
    
    func verifyCode(email: String, code: String, completionHandler: @escaping (String?) -> Void) {
        
        let verifyData: Parameters = ["email": email, "code": code]
        
        requestWorker.post(url: Config.Routes.User.ResetPassword.VerifyCode, data: verifyData) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                completionHandler("Login Failed. Please try again later.")
            }
        }
    }
    
    func newPassword(email: String, code: String, password: String, passwordConfirmation: String, notificationToken: String, completionHandler: @escaping (UserModel?, String?) -> Void) {
        
        let verifyData: Parameters = [
            "email": email,
            "code": code,
            "password": password,
            "password_confirmation": passwordConfirmation,
            "notification_token": notificationToken
        ]
        
        requestWorker.post(url: Config.Routes.User.ResetPassword.NewPassword, data: verifyData) { (response: () throws -> Data) in
            do {
                let data = try response()
                
                let userDataResponse =  try self.jsonDecoder.decode(UserDataResponse.self, from: data)
                let user = self.createUserModel(userDataResponse: userDataResponse)
                
                completionHandler(user, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(nil, errorMessage)
            } catch {
                completionHandler(nil, "Failed To Reset Password. Please try again later.")
            }
        }
    }
    
}

extension ResetPasswordAPI {
    private func createUserModel(userDataResponse: UserDataResponse) -> UserModel {
        let userData = userDataResponse.data
        return UserModel(
            id: userData.id,
            name: userData.name,
            token: userData.token,
            email: userData.email,
            regionID: userData.region_id,
            supermarketChainID: userData.supermarket_chain_id,
            sendNotifications: userData.send_notifications
        )
    }
}
