//
//  ShowDetailsModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowDescription
{
  // MARK: Use cases
  
  enum GetDescription
  {
    struct Request
    {
    }
    struct Response
    {
        var description: String
    }
    struct ViewModel
    {
        var description: String
    }
  }
}