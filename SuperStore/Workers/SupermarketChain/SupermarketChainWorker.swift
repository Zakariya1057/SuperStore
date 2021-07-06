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
    private var defaultSupermarketChainID: Int = 1
    
    private var userStore: UserStoreProtocol = UserRealmStore()
    
    private var supermarketChains: [SupermarketChain] = [
        SupermarketChain(
            id: 1,
            name: "Real Canadian Superstore",
            type: .realCanadianSuperstore,
            logo: UIImage(named: "Real Canadian SuperStore")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChain(
            id: 2,
            name: "No Frills",
            type: .noFrills,
            logo: UIImage(named: "No Frills")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChain(
            id: 3,
            name: "Atlantic Superstore",
            type: .atlanticSuperstore,
            logo: UIImage(named: "Real Canadian SuperStore")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
        
        SupermarketChain(
            id: 4,
            name: "Maxi",
            type: .maxi,
            logo: UIImage(named: "Real Canadian SuperStore")!,
            color: UIColor(red:0.10, green:0.29, blue:0.62, alpha:1.0)
        ),
    ]
    
    func getSupermarketChains() -> [SupermarketChain]{
        return supermarketChains
    }
    
    func getSelectedSupermarketChain() -> SupermarketChain {
        let supermarketChainID = userStore.getStoreID() ?? defaultSupermarketChainID
        
        return supermarketChains.first { (supermarketChain: SupermarketChain) in
            supermarketChain.id == supermarketChainID
        }!
    }
    
    func getSupermarketChainByID(supermarketChainID: Int) -> SupermarketChain? {
        return supermarketChains.first { (supermarketChain: SupermarketChain) in
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
