//
//  ParentCategoriesRouter.swift
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

@objc protocol ParentCategoriesRoutingLogic
{
  func routeToChildCategories(segue: UIStoryboardSegue?)
}

protocol ParentCategoriesDataPassing
{
  var dataStore: ParentCategoriesDataStore? { get }
}

class ParentCategoriesRouter: NSObject, ParentCategoriesRoutingLogic, ParentCategoriesDataPassing
{
  weak var viewController: ParentCategoriesViewController?
  var dataStore: ParentCategoriesDataStore?
  
  // MARK: Routing
  
  func routeToChildCategories(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! ChildCategoriesViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToChildCategories(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChildCategoriesViewController") as! ChildCategoriesViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToChildCategories(source: dataStore!, destination: &destinationDS)
      navigateToChildCategories(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation
  
  func navigateToChildCategories(source: ParentCategoriesViewController, destination: ChildCategoriesViewController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToChildCategories(source: ParentCategoriesDataStore, destination: inout ChildCategoriesDataStore)
  {
    destination.parentCategoryID = source.categories[ viewController!.categoriesTableView.indexPathForSelectedRow!.row ].id
  }
}