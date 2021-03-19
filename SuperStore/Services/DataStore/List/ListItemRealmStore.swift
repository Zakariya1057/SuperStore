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
    
    lazy var listStore: ListRealmStore = ListRealmStore()
    
    func getListItemObject(itemID: Int) -> ListItemObject? {
        return realm?.objects(ListItemObject.self).filter("id = %@", itemID).first
    }
    
    func getListItemObject(listID: Int, productID: Int) -> ListItemObject? {
        return realm?.objects(ListItemObject.self).filter("listID = %@ AND productID = %@", listID, productID).first
    }
    
    
    func getListItems(listID: Int) -> [ListItemModel]{
        if let savedItems = realm?.objects(ListItemObject.self).filter("listID = %@", listID) {
            return savedItems.map{ $0.getListItemModel() }
        }
        
        return []
    }
    
    func getListItem(listID: Int, productID: Int) -> ListItemModel? {
        if let savedList = getListItemObject(listID: listID, productID: productID) {
            return savedList.getListItemModel()
        }
        
        return nil
    }
    
    func createListItem(listID: Int, listItem: ListItemModel, product: ProductModel? = nil) {
        if getListItemObject(listID: listID, productID: listItem.productID) == nil {
            
            listStore.listEdited(listID: listID)
            
            let savedListItem = createListItemObject(listItem: listItem, listID: listID)
            
            if let savedList = listStore.getListObject(listID: listID){
                
                try? realm?.write({
                    if let savedCategory = savedList.categories.filter("id = %@", product!.parentCategoryID!).first {
                        savedCategory.items.append(savedListItem)
                    } else {
                        let savedCategory = ListCategoryObject()
                        savedCategory.listID = listID
                        savedCategory.id = product!.parentCategoryID!
                        savedCategory.name = product!.parentCategoryName!
                        
                        savedCategory.items.append(savedListItem)
                        savedList.categories.append(savedCategory)
                    }
                })
                
                listStore.updateListTotalPrice(listID: listID)

            }
            
        }
    }
    
    func createListItemObject(listItem: ListItemModel, listID: Int) -> ListItemObject {
        let savedListItem = ListItemObject()

        savedListItem.id = listItem.id
        savedListItem.name = listItem.name
        savedListItem.image = listItem.image
        savedListItem.listID = listID
        savedListItem.price = listItem.price
        savedListItem.currency = listItem.currency
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
        
        return savedListItem
    }
    
    func updateListItem(listID: Int, productID: Int, quantity: Int, tickedOff: Bool){
        if let savedListItem = realm?.objects(ListItemObject.self).filter("productID = %@ AND listID = %@", productID, listID).first {
            
            listStore.listEdited(listID: listID)
            
            try? realm?.write({
                if quantity > 0 {
                    savedListItem.quantity = quantity
                    savedListItem.tickedOff = tickedOff
                } else {
                    realm?.delete(savedListItem)
                }
            })
            
            listStore.updateListTotalPrice(listID: listID)
        }
    }
    
    func deleteListItem(listID: Int, productID: Int) {
        if let savedListItem = realm?.objects(ListItemObject.self).filter("productID = %@ AND listID = %@", productID, listID).first {
            
            listStore.listEdited(listID: listID)
            
            try? realm?.write({
                // If last item in category, delete whole catgory
                
                if let savedList = listStore.getListObject(listID: listID) {
                    for (index, category) in savedList.categories.enumerated() {
                        for item in category.items {
                            if item.productID == productID {
                                // Find the correct category for list item.
                                if category.items.count == 1 {
                                    savedList.categories.remove(at: index)
                                }
                            }
                        }
                    }
                }
                
                realm?.delete(savedListItem)
            })
            
            listStore.updateListTotalPrice(listID: listID)
        }
    }
}
