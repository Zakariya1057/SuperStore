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
    
    private var regions: [RegionModel] = [
        RegionModel(id: 1, name: "Onatario", country: "Canada", storeTypeID: 2),
        RegionModel(id: 2, name: "Alberta", country: "Canada", storeTypeID: 2),
        RegionModel(id: 3, name: "Manitoba", country: "Canada", storeTypeID: 2),
        RegionModel(id: 4, name: "British Columbia", country: "Canada", storeTypeID: 2),
        RegionModel(id: 5, name: "Saskatchewan", country: "Canada", storeTypeID: 2),
        RegionModel(id: 6, name: "Yukon", country: "Canada", storeTypeID: 2),
    ]
    
    func getRegions() -> [RegionModel]{
        return regions
    }
    
    func getSelectedRegion() -> RegionModel {
        return regions.first { (regions: RegionModel) in
            regions.id == defaultRegionID
        }!
    }
    
    func getRegionName(regionID: Int) -> String {
        return regions.first { (region: RegionModel) in
            return region.id == regionID
        }!.name
    }
}
