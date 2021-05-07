//
//  AllPromotionsModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 07/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum AllPromotions
{
  // MARK: Use cases
  
  enum GetAllPromotions
  {
    struct Request
    {
    }
    
    struct Response
    {
        var promotions: [PromotionModel] = []
        var error: String?
        var offline: Bool = false
    }
    
    struct ViewModel
    {
        var promotions: [PromotionModel] = []
        var error: String?
        var offline: Bool = false
    }
  }
}
