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
    
    let userSession = UserSession()
    
    let requestTimeout: Double = 15
    
    func parseURL(urlString:String) -> String {
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func getRequest(url urlString: String,complete: @escaping (_ data:Data) -> Void,error: @escaping (_ message:String) -> Void ){
        
        let urlString = parseURL(urlString: urlString)
        
        let token = userSession.getUserToken()!
        
        print("Token: \(token)")
        
        let headers: HTTPHeaders = [
            "X-Authorization": "Bearer \(token)",
            "X-Requested-With": "XMLHttpRequest"
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
        
        let token = userSession.getUserToken() ?? ""
        
        print("POST REQUEST: \(urlString)")
        
//        let token = "1|7V4iFvllGXQvS951LOg6nH5URlR49XCH7giatCLX"
        
        let headers: HTTPHeaders = [
            "X-Authorization": "Bearer \(token)",
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
            error(errorMessage)
            
        }
        
    }
}
