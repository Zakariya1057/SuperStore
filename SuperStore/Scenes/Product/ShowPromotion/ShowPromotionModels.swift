//
//  ShowPromotionModels.swift
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

enum ShowPromotion
{
  // MARK: Use cases
  
  enum GetPromotion
  {
    struct Request
    {
    }
    struct Response
    {
        var promotion: PromotionModel?
        var error: String?
        var offline: Bool = false
    }
    struct ViewModel
    {
        var promotion: PromotionModel?
        var error: String?
        var offline: Bool = false
    }
  }
}
