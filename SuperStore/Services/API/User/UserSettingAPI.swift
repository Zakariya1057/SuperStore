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
    
    func updateUser(data: [String : String], type: String, completionHandler: @escaping (String?) -> Void) {
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
