//
//  ShowSuggestionsRouter.swift
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

@objc protocol ShowSuggestionsRoutingLogic
{
    func routeToShowProductResults(segue: UIStoryboardSegue?)
    func routeToShowStoreResults(segue: UIStoryboardSegue?)
    func routeToShowList(segue: UIStoryboardSegue?)
}

protocol ShowSuggestionsDataPassing
{
    var dataStore: ShowSuggestionsDataStore? { get }
    var selectedStoreTypeID: Int? { get set }
}

class ShowSuggestionsRouter: BackToShowListRouter, ShowSuggestionsRoutingLogic, ShowSuggestionsDataPassing
{
    var showSuggestionsViewController: ShowSuggestionsViewController {
        return viewController as! ShowSuggestionsViewController
    }
    
    var dataStore: ShowSuggestionsDataStore?
    var selectedStoreTypeID: Int?
    var selectedListID: Int?
    
    // MARK: Routing
    
    func routeToShowStoreResults(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowStoreResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowStoreResults(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowStoreResultsViewController") as! ShowStoreResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowStoreResults(source: dataStore!, destination: &destinationDS)
            navigateToShowStoreResults(source: showSuggestionsViewController, destination: destinationVC)
        }
    }
    
    func routeToShowProductResults(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowProductResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowProductResultsViewController") as! ShowProductResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
            navigateToShowProductResults(source: showSuggestionsViewController, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToShowStoreResults(source: ShowSuggestionsViewController, destination: ShowStoreResultsViewController)
    {
      source.show(destination, sender: nil)
    }
    
    func navigateToShowProductResults(source: ShowSuggestionsViewController, destination: ShowProductResultsViewController)
    {
      source.show(destination, sender: nil)
    }
    
    
    // MARK: Passing data
    
    func passDataToShowStoreResults(source: ShowSuggestionsDataStore, destination: inout ShowStoreResultsDataStore)
    {
        destination.storeTypeID = selectedStoreTypeID!
        destination.selectedListID = source.selectedListID
    }
    
    func passDataToShowProductResults(source: ShowSuggestionsDataStore, destination: inout ShowProductResultsDataStore)
    {
        destination.searchQueryRequest = source.searchQueryRequest!
        destination.selectedListID = source.selectedListID
    }
    

}
