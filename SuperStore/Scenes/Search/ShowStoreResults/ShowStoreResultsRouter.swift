//
//  ShowStoreResultsRouter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ShowStoreResultsRoutingLogic
{
    func routeToStore(segue: UIStoryboardSegue?)
    func routeToShowList(segue: UIStoryboardSegue?)
}

protocol ShowStoreResultsDataPassing
{
    var dataStore: ShowStoreResultsDataStore? { get }
    var selectedStoreID: Int? { get set }
}

class ShowStoreResultsRouter: BackToShowListRouter, ShowStoreResultsRoutingLogic, ShowStoreResultsDataPassing
{
    var showStoreResultsViewController: ShowStoreResultsViewController {
        return viewController as! ShowStoreResultsViewController
    }
    
    var dataStore: ShowStoreResultsDataStore?
    var selectedStoreID: Int?
    
    // MARK: Routing
    
    func routeToStore(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! StoreViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStore(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStore(source: dataStore!, destination: &destinationDS)
            navigateToStore(source: showStoreResultsViewController, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToStore(source: ShowStoreResultsViewController, destination: StoreViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToStore(source: ShowStoreResultsDataStore, destination: inout StoreDataStore)
    {
        destination.storeID = selectedStoreID!
        destination.selectedListID = source.selectedListID
    }
}
