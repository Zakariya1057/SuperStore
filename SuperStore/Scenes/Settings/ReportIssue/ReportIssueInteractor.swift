//
//  ReportIssueInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReportIssueBusinessLogic
{
    func sendIssue(request: ReportIssue.SendIssue.Request)
}

protocol ReportIssueDataStore
{
}

class ReportIssueInteractor: ReportIssueBusinessLogic, ReportIssueDataStore
{
    var presenter: ReportIssuePresentationLogic?
    var reportWorker: ReportWorker = ReportWorker(reportAPI: ReportAPI())
    
    func sendIssue(request: ReportIssue.SendIssue.Request)
    {
        let issue: String = request.issue
        reportWorker.sendIssue(issue: issue) { (error: String?) in
            let response = ReportIssue.SendIssue.Response(error: error)
            self.presenter?.presentSendIssue(response: response)
        }
    }
}