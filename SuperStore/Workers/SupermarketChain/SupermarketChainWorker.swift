//
//  SupermarketChainWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 26/05/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import UIKit

class SupermarketChainWorker
{
    private var defaultSupermarketChainID: Int = 3
    
    private var userStore: UserStoreProtocol = UserRealmStore()
    private lazy var regionWorker: RegionWorker = RegionWorker()
    
    // Only show some supermarket chains for some regions.
    private var supermarketChains: [SupermarketChainModel] = [
        SupermarketChainModel(
            id: 1,
            name: "Real Canadian Superstore",
            type: .realCanadianSuperstore,
            logo: UIImage(named: "Real Canadian SuperStore")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChainModel(
            id: 2,
            name: "No Frills",
            type: .noFrills,
            logo: UIImage(named: "No Frills")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChainModel(
            id: 3,
            name: "Atlantic Superstore",
            type: .atlanticSuperstore,
            logo: UIImage(named: "Atlantic Superstore")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChainModel(
            id: 4,
            name: "Maxi",
            type: .maxi,
            logo: UIImage(named: "Maxi")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
    ]
    
    func getSupermarketChains() -> [SupermarketChainModel]{
        return supermarketChains
    }
    
    func getSelectedSupermarketChain() -> SupermarketChainModel {
        let supermarketChainID = userStore.getStoreID() ?? defaultSupermarketChainID
        
        return supermarketChains.first { (supermarketChain: SupermarketChainModel) in
            supermarketChain.id == supermarketChainID
        }!
    }
    
    func getSupermarketChainByID(supermarketChainID: Int) -> SupermarketChainModel? {
        return supermarketChains.first { (supermarketChain: SupermarketChainModel) in
            return supermarketChain.id == supermarketChainID
        }
    }
    
    func getSupermarketChainName(supermarketChainID: Int) -> String {
        return getSupermarketChainByID(supermarketChainID: supermarketChainID)?.name ?? supermarketChains.first!.name
    }
    
    func getSupermarketChainLogo(supermarketChainID: Int) -> UIImage? {
        if let supermarketChain = getSupermarketChainByID(supermarketChainID: supermarketChainID) {
            return supermarketChain.logo
        }

        return nil
    }
}

extension SupermarketChainWorker {
    func getSupermarketChainsSorted(excludeSupermarketChainIDs: [Int] = []) -> [SupermarketChainModel] {
        var supermarketChains = getSupermarketChainsExcluding(excludeSupermarketChainIDs: excludeSupermarketChainIDs)
        let selectedSupermarketChain = getSelectedSupermarketChain()
        
        if let index = supermarketChains.firstIndex(where: { $0.id == selectedSupermarketChain.id }) {
            supermarketChains.remove(at: index)
            supermarketChains.insert(selectedSupermarketChain, at: 0)
        }
        
        return supermarketChains
    }
    
    func getSupermarketChainsExcluding(excludeSupermarketChainIDs: [Int]) -> [SupermarketChainModel] {
        return supermarketChains.filter { supermarketChain in !excludeSupermarketChainIDs.contains(supermarketChain.id) }
    }
}

extension SupermarketChainWorker {
    func getCurrentRegionSupermarketChains() -> [SupermarketChainModel] {
        return regionWorker.getSelectedRegion().supermarketChains
    }
}
