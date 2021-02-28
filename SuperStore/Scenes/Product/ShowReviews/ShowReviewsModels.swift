//
//  ShowReviewsModels.swift
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

enum ShowReviews
{
    // MARK: Use cases
    
    enum GetReviews
    {
        struct Request
        {
        }
        struct Response
        {
            var reviews: [ReviewModel]
            var error: String?
        }
        struct ViewModel
        {
            var reviews: [ReviewModel]
            var error: String?
        }
    }
}
