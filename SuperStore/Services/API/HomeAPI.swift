//
//  HomeAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class HomeAPI: HomeProtocol {

    let jsonDecoder = JSONDecoder()
    
    let requestWorker: RequestProtocol = RequestWorker()

    func getHome(completionHandler: @escaping (_ homeModel: Home.GetHome.Response, _ error: String?) -> Void) {
        
//        requestWorker.post(url: Config.Route.User.ResetPassword.SendEmail, data: ["email": email]) { (response: () throws -> Data) in
//            do {
//                _ = try response()
//                completionHandler(nil)
//            } catch RequestError.Error(let errorMessage){
//                print(errorMessage)
//                completionHandler(errorMessage)
//            } catch {
//                completionHandler("Login Failed. Please try again later.")
//            }
//        }
    }
}

extension HomeAPI {
    private func createHomeItems(userResponseData: UserDataResponse?) -> UserLoginModel? {
        
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
