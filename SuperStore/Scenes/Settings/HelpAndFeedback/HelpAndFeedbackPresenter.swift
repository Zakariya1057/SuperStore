//
//  HelpAndFeedbackPresenter.swift
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

protocol HelpAndFeedbackPresentationLogic
{
    func presentSettings(response: HelpAndFeedback.GetSettings.Response)
}

class HelpAndFeedbackPresenter: HelpAndFeedbackPresentationLogic
{
    weak var viewController: HelpAndFeedbackDisplayLogic?
    
    // MARK: Do something
    
    func presentSettings(response: HelpAndFeedback.GetSettings.Response)
    {
        var displaySections: [HelpAndFeedback.DisplaySection] = []

        if response.loggedIn {
            displaySections.append(HelpAndFeedback.DisplaySection(settings: [
                SettingModel(name: "Help", type: .help)
            ]))
        }
        
        displaySections.append(HelpAndFeedback.DisplaySection(settings: [
            SettingModel(name: "Suggest A Feature", type: .feature),
            SettingModel(name: "Feedback", type: .feedback)
        ]))
        
        
        displaySections.append(HelpAndFeedback.DisplaySection(settings: [
            SettingModel(name: "Report An Issue", type: .issue),
        ]))
        
        let viewModel = HelpAndFeedback.GetSettings.ViewModel(displaySections: displaySections)
        viewController?.displaySettings(viewModel: viewModel)
    }
}