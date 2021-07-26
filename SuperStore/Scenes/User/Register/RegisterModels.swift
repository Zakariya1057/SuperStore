//
//  RegisterModels.swift
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

enum Register
{
    // MARK: Use cases
    
    enum GetRegions
    {
        struct Request
        {
        }
        struct Response
        {
            var regions: [RegionModel]
            var selectedRegion: RegionModel
        }
        struct ViewModel
        {
            var regions: [RegionModel]
            var selectedRegion: RegionModel
        }
    }
    
    enum Register
    {
        struct Request
        {
            var name: String
            var email: String
            var password: String
            var passwordConfirm: String
            var regionID: Int
            var supermarketChainID: Int
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
    
    enum GetEmail
    {
        struct Request
        {
        }
        struct Response
        {
            var email: String?
        }
        struct ViewModel
        {
            var email: String?
        }
    }
}
