//
//  GrandParentCategoriesModels.swift
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

enum GrandParentCategories
{
  enum GetCategories
  {
    struct Request
    {
    }
    
    struct Response
    {
        var categories: [GrandParentCategoryModel]
        var error: String?
        var offline: Bool = false
    }
    
    struct ViewModel
    {
        struct DisplayedCategory {
            var name: String
        }
        
        var displayedCategories: [DisplayedCategory]
        
        var error: String?
        var offline: Bool = false
    }
  }
}
