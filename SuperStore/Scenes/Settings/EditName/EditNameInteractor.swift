//
//  EditNameInteractor.swift
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

protocol EditNameBusinessLogic
{
  func getName(request: EditName.GetName.Request)
}

protocol EditNameDataStore
{
  var name: String { get set }
}

class EditNameInteractor: EditNameBusinessLogic, EditNameDataStore
{
  var presenter: EditNamePresentationLogic?
  var worker: EditNameWorker?
  var name: String = ""
  
  // MARK: Do something
  
  func getName(request: EditName.GetName.Request)
  {
    worker = EditNameWorker()
    worker?.doSomeWork()
    
    let response = EditName.GetName.Response(name: name)
    presenter?.presentName(response: response)
  }
}
