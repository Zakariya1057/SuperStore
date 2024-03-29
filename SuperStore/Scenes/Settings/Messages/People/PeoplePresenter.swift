//
//  PeoplePresenter.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 25/08/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PeoplePresentationLogic
{
  func presentSomething(response: People.Something.Response)
}

class PeoplePresenter: PeoplePresentationLogic
{
  weak var viewController: PeopleDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: People.Something.Response)
  {
    let viewModel = People.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
