//
//  HelpAndFeedbackInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/06/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HelpAndFeedbackBusinessLogic
{
    func getSettings(request: HelpAndFeedback.GetSettings.Request)
    
    func setFeedbackTitle(setting: SettingModel)
}

protocol HelpAndFeedbackDataStore
{
    var selectedSetting: SettingModel! { get set }
}

class HelpAndFeedbackInteractor: HelpAndFeedbackBusinessLogic, HelpAndFeedbackDataStore
{
    var presenter: HelpAndFeedbackPresentationLogic?
    
    var userSession: UserSessionWorker = UserSessionWorker()
    var messageWorker: MessageWorker = MessageWorker(messageAPI: MessageAPI())
    
    var selectedSetting: SettingModel!
    
    func getSettings(request: HelpAndFeedback.GetSettings.Request)
    {
        let unreadHelpMessages: Int = messageWorker.getUnreadMessagesCountByType(type: .help)
        let unreadFeaturepMessages: Int = messageWorker.getUnreadMessagesCountByType(type: .feature)
        let unreadFeedbackMessages: Int = messageWorker.getUnreadMessagesCountByType(type: .feedback)
        let unreadIssueMessages: Int =  messageWorker.getUnreadMessagesCountByType(type: .issue)
        
        let loggedIn: Bool = userSession.isLoggedIn()
        
        let response = HelpAndFeedback.GetSettings.Response(
            unreadHelpMessages: unreadHelpMessages,
            unreadFeaturepMessages: unreadFeaturepMessages,
            unreadIssueMessages: unreadIssueMessages,
            unreadFeedbackMessages: unreadFeedbackMessages,
            
            loggedIn: loggedIn
        )
        
        presenter?.presentSettings(response: response)
    }
    
    func setFeedbackTitle(setting: SettingModel){
        self.selectedSetting = setting
    }
}
