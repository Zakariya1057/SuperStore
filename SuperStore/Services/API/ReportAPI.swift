//
//  ReportIssueAPI.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ReportAPI: API, ReportRequestProtocol {
    
    func sendIssue(issue: String, completionHandler: @escaping (String?) -> Void) {
        requestWorker.post(url: Config.Route.Report.Issue, data: ["issue": issue]) { (response: () throws -> Data) in
            do {
                _ = try response()
                completionHandler(nil)
            } catch RequestError.Error(let errorMessage){
                print(errorMessage)
                completionHandler(errorMessage)
            } catch {
                print(error)
                completionHandler("Failed to report issue. Decoding error, please try again later.")
            }
        }
    }
}
