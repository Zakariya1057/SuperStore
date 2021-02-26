//
//  NewPasswordInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NewPasswordBusinessLogic
{
  func doSomething(request: NewPassword.Something.Request)
}

protocol NewPasswordDataStore
{
  //var name: String { get set }
}

class NewPasswordInteractor: NewPasswordBusinessLogic, NewPasswordDataStore
{
  var presenter: NewPasswordPresentationLogic?
  var worker: NewPasswordWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: NewPassword.Something.Request)
  {
    worker = NewPasswordWorker()
    worker?.doSomeWork()
    
    let response = NewPassword.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
