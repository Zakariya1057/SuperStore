//
//  FeedbackAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class FeedbackAPI: API, FeedbackRequestProtocol {
    func sendFeedback(type: SettingType, message: String, completionHandler: @escaping (String?) -> Void) {
        let url: String = Config.Routes.Feedback.Create
        
        requestWorker.post(url: url, data: ["type": type.rawValue, "message": message]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to send feedback. Decoding error, please try again later.")
            }
        }
    }
}
