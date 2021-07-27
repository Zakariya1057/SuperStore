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
    private var defaultRegionID: Int = 8
    
    private var userStore: UserStoreProtocol = UserRealmStore()
    
    private lazy var supermarketChainWorker: SupermarketChainWorker = SupermarketChainWorker()
    
    // Select your regions, see supermarket chains in those regions
    private var regions: [RegionModel] {
        [
            RegionModel(
                id: 8,
                name: "Ontario",
                country: "Canada"
            ),

            RegionModel(
                id: 9,
                name: "Alberta",
                country: "Canada"
            ),

            RegionModel(
                id: 10,
                name: "Manitoba",
                country: "Canada"
            ),

            RegionModel(
                id: 11,
                name: "British Columbia",
                country: "Canada"
            ),

            RegionModel(
                id: 12,
                name: "Saskatchewan",
                country: "Canada"
            ),

            RegionModel(
                id: 13,
                name: "Yukon",
                country: "Canada"
            ),

            
            RegionModel(
                id: 18,
                name: "Quebec",
                country: "Canada"
            ),
            
        
            RegionModel(
                id: 14,
                name: "Newfoundland and Labrador",
                country: "Canada"
            ),

            RegionModel(
                id: 15,
                name: "Nova Scotia",
                country: "Canada"
            ),

            RegionModel(
                id: 16,
                name: "Prince Edward Island",
                country: "Canada"
            ),

            RegionModel(
                id: 17,
                name: "New Brunswick",
                country: "Canada"
            ),

        ]
    
    }
    
    func getRegions() -> [RegionModel]{
        return regions
    }
    
}

extension RegionWorker {
    func getRegion(regionID: Int) -> RegionModel? {
        return regions.first { (region: RegionModel) in
            return region.id == regionID
        }
    }
}

extension RegionWorker {
    func getSelectedRegion() -> RegionModel {
        let regionID = userStore.getRegionID() ?? defaultRegionID
        return getRegion(regionID: regionID)!
    }
    
    
    func getRegionName(regionID: Int) -> String {
        return getRegion(regionID: regionID)?.name ?? regions.first!.name
    }
    
//    func getRegionSupermarketChainID(regionID: Int) -> Int {
//        let region: RegionModel = getRegion(regionID: regionID) ?? regions.first!
//        return region.supermarketChains.first!.id
//    }
}

extension RegionWorker {
    func getRegionsForSupermarketChain() -> [RegionModel] {
        return supermarketChainWorker.getSelectedSupermarketChain().regions
    }
    
    func getRegionsByID(ids: [Int]) -> [RegionModel] {
        return regions.filter { region in ids.contains(region.id) }
    }
    
}
