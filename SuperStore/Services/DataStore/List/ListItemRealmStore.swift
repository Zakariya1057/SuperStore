//
//  ListItemRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ListItemRealmStore: DataStore, ListItemStoreProtocol {
    
    func getListItemObject(itemID: Int) -> ListItemObject? {
        return realm?.objects(ListItemObject.self).filter("id = %@", itemID).first
    }
    
    func getListItemObject(listID: Int, productID: Int) -> ListItemObject? {
        return realm?.objects(ListItemObject.self).filter("listID = %@ AND productID = %@", listID, productID).first
    }
    
    func getListItem(listID: Int, productID: Int) -> ListItemModel? {
        if let savedList = getListItemObject(listID: listID, productID: productID) {
            return savedList.getListItemModel()
        }
        
        return nil
    }
    
    func createListItem(listID: Int, listItem: ListItemModel) {
        if getListItemObject(itemID: listItem.id) == nil {
            try? realm?.write({
                let savedListItem = ListItemObject()

                savedListItem.id = listItem.id
                savedListItem.name = listItem.name
                savedListItem.image = listItem.image
                savedListItem.listID = listID
                savedListItem.price = listItem.price
                savedListItem.totalPrice = listItem.totalPrice
                savedListItem.productID = listItem.productID
                savedListItem.quantity = listItem.quantity

                var savedPromotion: PromotionObject?

                if let promotion = listItem.promotion {
                    savedPromotion = PromotionObject()
                    savedPromotion?.id = promotion.id
                    savedPromotion?.name = promotion.name
                    savedPromotion?.forQuantity = promotion.forQuantity
                    savedPromotion?.endsAt = promotion.endsAt
                    savedPromotion?.startsAt = promotion.startsAt
                    savedPromotion?.price = promotion.price
                }

                savedListItem.promotion = savedPromotion

                realm?.add(savedListItem)
            })
        }
    }
    
    func updateListItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool){
        if let savedListItem = realm?.objects(ListItemObject.self).filter("productID = %@ AND listID = %@", productID, listID).first {
            try? realm?.write({
                savedListItem.quantity = quantity
                savedListItem.tickedOff = tickedOff
            })
        }
    }
    
    func deleteListItem(listID: Int, productID: Int) {
        if let savedListItem = realm?.objects(ListItemObject.self).filter("productID = %@ AND listID = %@", productID, listID).first {
            try? realm?.write({
                realm?.delete(savedListItem)
            })
        }
    }
}
