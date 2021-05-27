//
//  FlyerAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FlyerAPI: API, FlyerRequestProtocol {
    func getFlyers(storeID: Int, completionHandler: @escaping ([FlyerModel], String?) -> Void) {
        let url = Config.Route.Flyers + String(storeID)
        
        requestWorker.get(url:url) { (response: () throws -> Data) in
            do {
                let data = try response()
                let flyersDataResponse =  try self.jsonDecoder.decode(FlyersDataResponse.self, from: data)
                let flyers = self.createFlyersModel(flyersDataResponse: flyersDataResponse)
                completionHandler(flyers, nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler([], errorMessage)
            } catch {
                print(error)
                completionHandler([], "Failed to get flyers. Decoding error, please try again later.")
            }
        }
    }
}

extension FlyerAPI {
    private func createFlyersModel(flyersDataResponse: FlyersDataResponse) -> [FlyerModel] {
        let flyersData: [FlyerData] = flyersDataResponse.data
        return flyersData.map { (flyer: FlyerData) in
            return flyer.getFlyerModel()
        }
    }
}
