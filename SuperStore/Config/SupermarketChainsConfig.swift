//
//  File.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 28/07/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol SupermarketChainDetails {
    var SupermarketChainID: Int { get }
    var RegionID: Int { get }
}


struct SupermarketChainsConfig {
    private static var selectedSupermarketChainID: Int = 2
    
    public static var SelectedSupermarketChain: SupermarketChainDetails! {
        
        switch selectedSupermarketChainID {
            case 1:
                return RealCanadianSuperstore()
            case 2:
                return NoFrills()
            case 3:
                return AtlanticSuperstore()
            case 4:
                return Maxi()
        default:
            return RealCanadianSuperstore()
        }
        
    }
    
    private struct RealCanadianSuperstore: SupermarketChainDetails {
        var SupermarketChainID: Int = 1
        var RegionID: Int = 8
    }
    
    private struct NoFrills: SupermarketChainDetails {
        var SupermarketChainID: Int = 2
        var RegionID: Int = 8
    }
    
    private struct AtlanticSuperstore: SupermarketChainDetails {
        var SupermarketChainID: Int = 3
        var RegionID: Int = 15
    }
    
    private struct Maxi: SupermarketChainDetails {
        var SupermarketChainID: Int = 4
        var RegionID: Int = 18
    }
}
