//
//  UserSettingAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class UserSettingAPI: UserRequestProtocol {
    
    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()
        
    func updatePassword(currentPassword: String, newPassword: String, confirmPassword: String, completionHandler: @escaping (String?) -> Void) {
        let updateData: Parameters = [
            "current_password": currentPassword,
            "password": newPassword,
            "password_confirmation": confirmPassword
        ]
        
        requestUpdateUser(data: updateData, type: "password", completionHandler: completionHandler)
    }
    
    func updateName(name: String, completionHandler: @escaping (String?) -> Void) {
        let updateData: Parameters = ["name": name]
        requestUpdateUser(data: updateData, type: "name", completionHandler: completionHandler)
    }
    
    func updateEmail(email: String, completionHandler: @escaping (String?) -> Void) {
        let updateData: Parameters = ["email": email]
        requestUpdateUser(data: updateData, type: "email", completionHandler: completionHandler)
    }
    
    func updateNotifications(sendNotifications: Bool, completionHandler: @escaping (String?) -> Void) {
        let updateData: Parameters = ["send_notifications": sendNotifications]
        requestUpdateUser(data: updateData, type: "send_notifications", completionHandler: completionHandler)
    }
    
    
    func logout(completionHandler: @escaping (_ error: String?) -> Void){
        requestWorker.post(url: Config.Route.User.Logout, data: nil) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                completionHandler("Logout failed. Please try again later.")
            }
        }
    }
    
    func deleteUser(completionHandler: @escaping (_ error: String?) -> Void){
        
        requestWorker.post(url: Config.Route.User.Delete, data: nil) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                completionHandler("Delete failed. Please try again later.")
            }
        }
    }
}

extension UserSettingAPI {
    private func requestUpdateUser(data: Parameters, type: String, completionHandler: @escaping (String?) -> Void) {
        var updateData: Parameters = data
        updateData["type"] = type.lowercased()

        requestWorker.post(url: Config.Route.User.Update, data: updateData) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                completionHandler("Update failed. Please try again later.")
            }
        }
        
    }
}
