//
//  ReportIssue.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ReportWorker
{
    private var reportAPI: ReportRequestProtocol
    
    init(reportAPI: ReportRequestProtocol) {
        self.reportAPI = reportAPI
    }
    
    func sendIssue(issue: String, completionHandler: @escaping (_ error: String?) -> Void){
        reportAPI.sendIssue(issue: issue, completionHandler: { (error) in
            completionHandler(error)
        })
    }
}

protocol ReportRequestProtocol {
    func sendIssue(issue: String, completionHandler: @escaping (_ error: String?) -> Void)
}
