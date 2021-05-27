//
//  StoreTypeWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UIKit

class StoreTypeWorker
{
    private var defaultStoreTypeID: Int = 2
    
    private var userStore: UserStoreProtocol = UserRealmStore()
    
    private var storeTypes: [StoreTypeModel] = [
        StoreTypeModel(
            id: 1,
            name: "Asda",
            type: .asda,
            color: UIColor(red:0.51, green:0.67, blue:0.24, alpha:1.0)
        ),
        
        StoreTypeModel(
            id: 2,
            name: "Real Canadian Superstore",
            type: .realCanadianSuperstore,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
    ]
    
    func getStoreTypes() -> [StoreTypeModel]{
        return storeTypes
    }
    
    func getSelectedStoreType() -> StoreTypeModel {
        let storeTypeID = userStore.getStoreID() ?? defaultStoreTypeID
        
        return storeTypes.first { (storeType: StoreTypeModel) in
            storeType.id == storeTypeID
        }!
    }
    
    func getStoreName(storeTypeID: Int) -> String {
        return storeTypes.first { (storeType: StoreTypeModel) in
            return storeType.id == storeTypeID
        }!.name
    }
}
