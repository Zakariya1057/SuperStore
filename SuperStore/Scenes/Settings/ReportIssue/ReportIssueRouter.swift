//
//  ReportIssueRouter.swift
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

@objc protocol ReportIssueRoutingLogic
{
    func routeToSettings(segue: UIStoryboardSegue?)
}

protocol ReportIssueDataPassing
{
    var dataStore: ReportIssueDataStore? { get }
}

class ReportIssueRouter: NSObject, ReportIssueRoutingLogic, ReportIssueDataPassing
{
    weak var viewController: ReportIssueViewController?
    var dataStore: ReportIssueDataStore?
    
    // MARK: Routing
    
    func routeToSettings(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! SettingsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSettings(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSettings(source: dataStore!, destination: &destinationDS)
            navigateToSettings(source: viewController!, destination: destinationVC)
        }
    }
    
    //   MARK: Navigation
    
    func navigateToSettings(source: ReportIssueViewController, destination: SettingsViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    //   MARK: Passing data
    
    func passDataToSettings(source: ReportIssueDataStore, destination: inout SettingsDataStore)
    {
    }
}
