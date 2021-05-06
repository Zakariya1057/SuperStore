//
//  LocationAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 15/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class LocationAPI: API, LocationRequestProtocol {

    func updateLocation(latitude: Double, longitude: Double, completionHandler: @escaping ( _ error: String?) -> Void){
        requestWorker.post(url: Config.Route.User.Location, data: ["latitude": latitude, "longitude": longitude]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to get product. Decoding error, please try again later.")
            }
        }
    }
    
}
