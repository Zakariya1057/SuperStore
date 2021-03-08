//
//  ShowListsRouter.swift
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

@objc protocol ShowListsRoutingLogic
{
    func routeToEditList(segue: UIStoryboardSegue?)
    func routeToShowList(segue: UIStoryboardSegue?)
    func routeToLogin(segue: UIStoryboardSegue?)
    func routeToShowProductResults(segue: UIStoryboardSegue?)
}

protocol ShowListsDataPassing
{
    var dataStore: ShowListsDataStore? { get }
    var listSelectedID: Int? { get set }
}

class ShowListsRouter: NSObject, ShowListsRoutingLogic, ShowListsDataPassing
{
    weak var viewController: ShowListsViewController?
    
    var dataStore: ShowListsDataStore?
    var listSelectedID: Int?
    
    // MARK: Routing
    
    func routeToShowProductResults(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowProductResultsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
            callListSelected(source: viewController!, destination: destinationVC)
        } else {

            let tabViewController = viewController!.presentingViewController as! UITabBarController
            let tabIndex: Int = tabViewController.selectedIndex
            
            let navigationViewController = tabViewController.viewControllers![tabIndex] as! UINavigationController
            
            let destinationVC = navigationViewController.viewControllers.last as! ShowProductResultsViewController

            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowProductResults(source: dataStore!, destination: &destinationDS)
            navigateToShowProductResults(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToEditList(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! EditListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditList(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "EditListViewController") as! EditListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditList(source: dataStore!, destination: &destinationDS)
            navigateToEditList(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowList(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "ShowListViewController") as! ShowListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowList(source: dataStore!, destination: &destinationDS)
            navigateToShowList(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToLogin(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! LoginViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToLogin(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToLogin(source: dataStore!, destination: &destinationDS)
            navigateToLogin(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToShowProductResults(source: ShowListsViewController, destination: ShowProductResultsViewController)
    {
        source.dismiss(animated: true, completion: {
            self.callListSelected(source: source, destination: destination)
        })
    }
    
    func navigateToEditList(source: ShowListsViewController, destination: EditListViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowList(source: ShowListsViewController, destination: ShowListViewController)
    {
        source.show(destination, sender: nil)
    }
    
    func navigateToLogin(source: ShowListsViewController, destination: LoginViewController)
    {
        source.present(destination, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToShowProductResults(source: ShowListsDataStore, destination: inout ShowProductResultsDataStore)
    {
    }
    
    func passDataToEditList(source: ShowListsDataStore, destination: inout EditListDataStore)
    {
        let list =  source.lists[ viewController!.editIndexPath!.row ]
        destination.list = list
    }
    
    func passDataToShowList(source: ShowListsDataStore, destination: inout ShowListDataStore)
    {
        let list =  source.lists[ viewController!.listsTableView.indexPathForSelectedRow!.row ]
        destination.list = list
    }
    
    func passDataToLogin(source: ShowListsDataStore, destination: inout LoginDataStore)
    {

    }
    
    //MARK: - User Logged In Callback
    func callListSelected(source: ShowListsViewController, destination: SelectListProtocol)
    {
        destination.listSelected(listID: listSelectedID!)
    }
}
