//
//  ListItemAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

class ListItemAPI {
    
    let jsonDecoder = JSONDecoder()
    let requestWorker: RequestProtocol = RequestWorker()

    func updateItem(listID: Int, productID: Int, quanity: Int, tickedOff: Bool, completionHandler: @escaping ( _ error: String?) -> Void){
        let url: String = Config.Route.List.ListRoute + String(listID) + Config.Route.List.Item.Update
        
        requestWorker.get(url: url) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to update list item. Decoding error, please try again later.")
            }
        }
    }
}
