//
//  EditPasswordRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 03/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EditPasswordRoutingLogic
{
    func routeToSettings(segue: UIStoryboardSegue?)
}

protocol EditPasswordDataPassing
{
    var dataStore: EditPasswordDataStore? { get }
}

class EditPasswordRouter: NSObject, EditPasswordRoutingLogic, EditPasswordDataPassing
{
    weak var viewController: EditPasswordViewController?
    var dataStore: EditPasswordDataStore?
    
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
    
    // MARK: Navigation
    
    func navigateToSettings(source: EditPasswordViewController, destination: SettingsViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToSettings(source: EditPasswordDataStore, destination: inout SettingsDataStore)
    {
        
    }
}
