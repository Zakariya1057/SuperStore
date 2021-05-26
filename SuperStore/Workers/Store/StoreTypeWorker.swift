//
//  StoreTypeWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class StoreTypeWorker
{
    private var defaultStoreTypeID: Int = 2
    
    private var storeTypes: [StoreTypeModel] = [
        StoreTypeModel(id: 1, name: "Asda", type: .asda),
        StoreTypeModel(id: 2, name: "Real Canadian Superstore", type: .realCanadianSuperstore),
    ]
    
    func getStoreTypes() -> [StoreTypeModel]{
        return storeTypes
    }
    
    func getSelectedStoreTypeID() -> StoreTypeModel {
        return storeTypes.first { (storeType: StoreTypeModel) in
            storeType.id == defaultStoreTypeID
        }!
    }
    
    func getStoreName(storeTypeID: Int) -> String {
        return storeTypes.first { (storeType: StoreTypeModel) in
            return storeType.id == storeTypeID
        }!.name
    }
}
