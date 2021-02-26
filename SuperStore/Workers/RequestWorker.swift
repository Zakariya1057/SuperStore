//
//  RequestWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/02/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestProtocol {
    func post(url: String, data:Parameters, completionHandler: @escaping ( () throws -> Data) -> Void)
    func get(url: String, completionHandler: @escaping ( () throws -> Data) -> Void)
    
    func responseHandler(response: AFDataResponse<Any>, completionHandler: @escaping ( () throws -> (Data)) -> Void)
}

enum RequestError: Error {
    case Error(String)
}

struct RequestWorker: RequestProtocol {

    var requestTimeout: Double = 10
    
    func get(url: String, completionHandler: @escaping (() throws -> Data) -> Void) {
        let urlString = parseURL(urlString: url)
        
        let headers: HTTPHeaders = setHeaders()
        
        print("GET REQUEST: \(urlString)")
        
        AF
            .request(urlString, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                responseHandler(response: response, completionHandler: completionHandler)
        }
    }
    
    func post(url: String, data:Parameters, completionHandler: @escaping ( () throws -> (Data)) -> Void) {
        let urlString = parseURL(urlString: url)

        let headers: HTTPHeaders = setHeaders()
        
        print("POST REQUEST: \(urlString)")
        AF.request(urlString, method: .post, parameters: ["data": data] ,encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = self.requestTimeout })
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                responseHandler(response: response, completionHandler: completionHandler)
            }
    }
    
    func responseHandler(response: AFDataResponse<Any>, completionHandler: @escaping ( () throws -> (Data)) -> Void) {
        
        switch response.result {
            case .success:
                completionHandler({
                    return response.data!
                })
                break
            case .failure(let errorResponse):
                print(errorResponse)
                completionHandler({
                    throw handlerResponseError(response: response, errorResponse: errorResponse)
                })
                break
        }
        
    }
    
    private func handlerResponseError(response: AFDataResponse<Any>, errorResponse: (AFError)) -> Error {
        if let data = response.data {
            let errorMessage = decodeErrorMessage(data: data)
            
            if let errorMessage = errorMessage {
                return RequestError.Error(errorMessage)
            }
           
        }
        
        return RequestError.Error(errorResponse.localizedDescription.replacingOccurrences(of: "URLSessionTask failed with error: ", with: ""))
    }
    
}

extension RequestWorker {
    private func parseURL(urlString:String) -> String {
        return urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    private func setHeaders() -> HTTPHeaders {
        let token = ""
        
        let headers: HTTPHeaders = [
            "X-Authorization": "Bearer \(token)",
            "X-Requested-With": "XMLHttpRequest",
        ]
        
        return headers
    }
    
    private func decodeErrorMessage(data: Data) -> String? {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(ErrorResponseData.self, from: data)
        return decodedData?.data.error
    }
}
