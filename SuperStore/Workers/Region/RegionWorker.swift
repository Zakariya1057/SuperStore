//
//  RegionWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class RegionWorker
{
    private var defaultRegionID: Int = 1
    
    private var userStore: UserStoreProtocol = UserRealmStore()
    
    private var regions: [RegionModel] = [
        RegionModel(id: 8, name: "Onatario", country: "Canada", storeTypeID: 2),
        RegionModel(id: 9, name: "Alberta", country: "Canada", storeTypeID: 2),
        RegionModel(id: 10, name: "Manitoba", country: "Canada", storeTypeID: 2),
        RegionModel(id: 11, name: "British Columbia", country: "Canada", storeTypeID: 2),
        RegionModel(id: 12, name: "Saskatchewan", country: "Canada", storeTypeID: 2),
        RegionModel(id: 13, name: "Yukon", country: "Canada", storeTypeID: 2),
    ]
    
    func getRegions() -> [RegionModel]{
        return regions
    }
    
    func getSelectedRegion() -> RegionModel {
        let regionID = userStore.getRegionID() ?? defaultRegionID
        
        return regions.first { (regions: RegionModel) in
            regions.id == regionID
        }!
    }
    
    func getRegionName(regionID: Int) -> String {
        return regions.first { (region: RegionModel) in
            return region.id == regionID
        }?.name ?? regions.first!.name
    }
}
