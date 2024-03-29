//
//  EditListRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EditListRoutingLogic
{
    func routeToShowLists(segue: UIStoryboardSegue?)
}

protocol EditListDataPassing
{
    var dataStore: EditListDataStore? { get }
}

class EditListRouter: NSObject, EditListRoutingLogic, EditListDataPassing
{
    weak var viewController: EditListViewController?
    var dataStore: EditListDataStore?
    
    // MARK: Routing
    
    func routeToShowLists(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowListsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowLists(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowListsViewController") as! ShowListsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowLists(source: dataStore!, destination: &destinationDS)
            navigateToShowLists(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToShowLists(source: EditListViewController, destination: ShowListsViewController)
    {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToShowLists(source: EditListDataStore, destination: inout ShowListsDataStore)
    {

    }
}
