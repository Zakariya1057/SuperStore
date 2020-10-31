//
//  RequestHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 31/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

struct RequestHandler {

    var offline: Bool = false
    
    static var sharedInstance: RequestHandler = {
        return RequestHandler()
    }()
    
    let userSession = UserSession()
    
    let requestTimeout: Double = 15
    
    func parseURL(urlString:String) -> String {
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func getRequest(url urlString: String,complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void,logOutUser: @escaping () -> Void){
        
        let urlString = parseURL(urlString: urlString)
        
        let token = userSession.getUserToken() ?? ""
        
        print("Token: \(token)")
        
        let headers: HTTPHeaders = [
            "X-Authorization": "Bearer \(token)",
            "X-Requested-With": "XMLHttpRequest",
        ]
        
        print("GET REQUEST: \(urlString)")
        
        AF
            .request(urlString, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.responseHandler(response: response, complete: complete, error: error,logOutUser: logOutUser)
        }
        
    }
    
    func postRequest(url urlString: String,data:[String: String],complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void, logOutUser: @escaping () -> Void ){
        
        let body:[String: [String: String]] = ["data": data]
        
        let urlString = parseURL(urlString: urlString)
        
        let token = userSession.getUserToken() ?? ""
        
        print("POST REQUEST: \(urlString)")
        
        let headers: HTTPHeaders = [
            "X-Authorization": "Bearer \(token)",
            "X-Requested-With": "XMLHttpRequest",
        ]
        
        AF.request(urlString, method: .post, parameters: body,encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.responseHandler(response: response, complete: complete, error: error,logOutUser: logOutUser)
        }
        
    }
    
    func responseHandler(response: AFDataResponse<Any>,complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void, logOutUser: @escaping () -> Void){
        
        switch response.result {
        
        case .success:
            complete(response.data!)
        case .failure(let errorResponse):
            
//            print(errorResponse)

            if RequestHandler.sharedInstance.offline {
                return print("Offline. Cancelling Error Message")
            }
            
            if(errorResponse.responseCode != nil && errorResponse.responseCode! == 401){
                logOutUser()
                error("Please try logging in again.")
             }

            var errorMessage:String = ""

            do {
                if let data = response.data {
                    let decoder = JSONDecoder()

                    let decodedData = try decoder.decode(ErrorDataResponse.self, from: data)
                    errorMessage = decodedData.data.error
                }

            } catch {
                print(error)
            }

            if errorMessage == "" && response.error != nil && response.error!.errorDescription != nil {
                errorMessage = "\(response.error!.errorDescription!)".replacingOccurrences(of: "URLSessionTask failed with error: ", with: "")
            }
            
            error(errorMessage)
            
        }
        
    }
    
    func serverReachable(){
        // Send request to servr, if successfull. Reachable otherwise Unreachable
    }
    
}
