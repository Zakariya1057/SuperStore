//
//  HomeModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/02/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Home
{
    // MARK: Use cases
    
    enum GetHome
    {
        struct Request
        {
            var latitude: Double?
            var longitude: Double?
        }
        struct Response
        {
            var home: HomeModel?
            var error: String?
        }
        struct ViewModel
        {
            var home: HomeModel?
            var error: String?
        }
    }
    
    enum UpdateLocation
    {
        struct Request
        {
            var longitude: Double
            var latitude: Double
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
}
