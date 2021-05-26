//
//  EditRegionPresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditRegionPresentationLogic
{
  func presentSomething(response: EditRegion.Something.Response)
}

class EditRegionPresenter: EditRegionPresentationLogic
{
  weak var viewController: EditRegionDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: EditRegion.Something.Response)
  {
    let viewModel = EditRegion.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}