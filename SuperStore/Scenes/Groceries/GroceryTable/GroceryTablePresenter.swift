//
//  GroceryTablePresenter.swift
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

protocol GroceryTablePresentationLogic
{
  func presentSomething(response: GroceryTable.Something.Response)
}

class GroceryTablePresenter: GroceryTablePresentationLogic
{
  weak var viewController: GroceryTableDisplayLogic?
  
  func presentSomething(response: GroceryTable.Something.Response)
  {
    let viewModel = GroceryTable.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
