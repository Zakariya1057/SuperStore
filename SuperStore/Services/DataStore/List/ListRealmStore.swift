//
//  ListRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ListRealmStore: DataStore, ListStoreProtocol {

    private func getListObject(listID: Int) -> ListObject? {
        return realm?.objects(ListObject.self).filter("id = %@", listID).first
    }
    
    func getList(listID: Int) -> ListModel? {
        
        if let savedList = getListObject(listID: listID) {
            return savedList.getListModel()
        }
        
        return nil
    }
    
    func getLists(storeTypeID: Int) -> [ListModel] {
        var lists: [ListModel] = []
        
        let savedLists = realm?.objects(ListObject.self).filter("storeTypeID = %@", storeTypeID)
        
        if let savedLists = savedLists {
            for list in savedLists {
                lists.append(list.getListModel() )
            }
        }
        
        return lists
    }
    
    func createList(list: ListModel){
        
        let duplicateList = getListObject(listID: list.id)
        
        if let duplicateList = duplicateList {
            print("List already created. Updating instead.")
            updateList(list: list, savedList: duplicateList)
            return
        }

        try? realm?.write({

            let savedList = ListObject()
            savedList.id = list.id
            savedList.name = list.name
            savedList.status = list.status.rawValue

            savedList.identifier = list.identifier
            savedList.storeTypeID = list.storeTypeID

            savedList.totalPrice = list.totalPrice
            savedList.oldTotalPrice = list.oldTotalPrice

            savedList.totalItems = list.totalItems
            savedList.tickedOffItems = list.tickedOffItems

            savedList.createdAt = list.createdAt
            savedList.updatedAt = list.updatedAt
            
            savedList.categories.removeAll()
            
            for category in createCategoryObjects(categories: list.categories) {
                savedList.categories.append(category)
            }
            
            realm?.add(savedList)

        })
    }
    
    func updateList(list: ListModel, savedList: ListObject){
        try? realm?.write({
            savedList.name = list.name
            savedList.status = list.status.rawValue
            savedList.totalPrice = list.totalPrice
            savedList.oldTotalPrice = list.oldTotalPrice
            savedList.totalItems = list.totalItems
            savedList.tickedOffItems = list.tickedOffItems
            savedList.updatedAt = list.updatedAt
            
            savedList.categories.removeAll()
            
            for category in createCategoryObjects(categories: list.categories) {
                savedList.categories.append(category)
            }
            
        })
    }
    
    func deleteList(listID: Int){
        try? realm?.write({
            let results = realm?.objects(ListObject.self).filter("id = %@", listID)
            if let results = results {
                realm?.delete(results)
            }
        })
    }
}

extension ListRealmStore {
    func createCategoryObjects(categories: [ListCategoryModel]) -> List<ListCategoryObject> {
        let savedCategories = List<ListCategoryObject>()
        
        for category in categories {
            
            let savedCategory = ListCategoryObject()
            
            savedCategory.id = category.id
            savedCategory.name = category.name
            
            for item in category.items {
                let savedItem = ListItemObject()

                savedItem.id = item.id
                savedItem.name = item.name
                savedItem.image = item.image
                savedItem.price = item.price
                savedItem.quantity = item.quantity
                savedItem.productID = item.productID
                savedItem.totalPrice = item.totalPrice
                savedItem.weight = item.weight
                savedItem.tickedOff = item.tickedOff

                savedCategory.items.append(savedItem)
            }
            
            savedCategories.append(savedCategory)
        }
        
        return savedCategories
    }
}
