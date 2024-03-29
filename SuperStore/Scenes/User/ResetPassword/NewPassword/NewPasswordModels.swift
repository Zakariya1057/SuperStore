//
//  NewPasswordModels.swift
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

enum NewPassword
{
  // MARK: Use cases
  
  enum NewPassword
  {
    struct Request
    {
        var password: String
        var passwordConfirm: String
    }
    struct Response
    {
        var error: String?
    }
    struct ViewModel
    {
        var error: String?
    }
  }
}
