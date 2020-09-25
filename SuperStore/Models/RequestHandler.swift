//
//  RequestHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 31/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

struct RequestHandler {
    
    let requestTimeout: Double = 15
    
    func parseURL(urlString:String) -> String {
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func getRequest(url urlString: String,complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void ){
        
        let urlString = parseURL(urlString: urlString)
        
//        let token = userSession.getUserToken()!
        let token = "S"
        
        print("Token: \(token)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Authorizations": "Bearer \(token)"
        ]
        
        print("GET REQUEST: \(urlString)")
        
        AF
            .request(urlString, headers: headers,requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.responseHandler(response: response, complete: complete, error: error)
        }
        
    }
    
    func postRequest(url urlString: String,data:[String: String],complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void ){
        
        let body:[String: [String: String]] = ["data": data]
        
        let urlString = parseURL(urlString: urlString)
        
//        let token = userSession.getUserToken() ?? ""
        
        print("POST REQUEST: \(urlString)")
        
        let token = "S"
        
        let headers: HTTPHeaders = [
            "Authorizations": "Bearer \(token)",
            "X-Requested-With": "XMLHttpRequest"
        ]
        
        AF.request(urlString, method: .post, parameters: body,encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headers,requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.responseHandler(response: response, complete: complete, error: error)
        }
        
    }
    
    func responseHandler(response: AFDataResponse<Any>,complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void){
        
        switch response.result {
        case .success:
            complete(response.data!)
        case .failure(let errorResponse):
            print(errorResponse)
//
//
//            if(errorResponse.responseCode != nil && errorResponse.responseCode! == 401){
//                 let userSession = UserSession()
//                 userSession.logOut()
//             }
//
//            var errorMessage:String = ""
//            var errorMessageFound:Bool = false
//
//            do {
//                if let data = response.data {
//                    let decoder = JSONDecoder()
//
//                    let decodedData = try decoder.decode(ErrorResponse.self, from: data)
//                    errorMessage = decodedData.message
//
//                    errorMessageFound = true
//                }
//
//            } catch {
//                print(error)
//            }
//
//            if(!errorMessageFound){
//
//                print("Error Occured: \(errorResponse)")
//
//                if errorResponse.errorDescription != nil {
//                    errorMessage = (errorResponse.errorDescription!)
//
//                    errorMessage = errorMessage.replacingOccurrences(of: ".", with: " ")
//                    errorMessage = errorMessage.replacingOccurrences(of: "URLSessionTask failed with error: ", with: "")
//                    errorMessage = errorMessage.replacingOccurrences(of: "Response status code was unacceptable: ", with: "Error ")
//
//                } else {
//                    if let errorCode = errorResponse.responseCode {
//                        errorMessage = "Error Code \(errorCode) "
//                    }
//                }
//
//                print("Error Description: \(errorMessage)")
//
//            }
//
//            error(errorMessage)
            
        }
        
    }
}
