//
//  ShowStoreResultsModels.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 02/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ShowStoreResults
{
    // MARK: Use cases
    
    struct DisplayedStore {
        var name: String
        var logo: String
        var logoImage: UIImage?
        var address: String
        var openingHour: String
    }
    
    enum GetStores
    {
        struct Request
        {
            var latitude: Double?
            var longitude: Double?
        }
        struct Response
        {
            var stores: [StoreModel]
            var error: String?
            var offline: Bool = false
        }
        struct ViewModel
        {
            var displayedStore: [DisplayedStore]
            var stores: [StoreModel]
            var error: String?
            var offline: Bool = false
        }
    }
}
