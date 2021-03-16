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
    
    func createList(list: ListModel, ignoreCategories: Bool = false){
        
        let duplicateList = getListObject(listID: list.id)
        
        if let duplicateList = duplicateList {
            print("List already created. Updating instead.")
            updateList(list: list, savedList: duplicateList, ignoreCategories: ignoreCategories)
            return
        }

        try? realm?.write({
            let savedList = createListObject(list: list)
            realm?.add(savedList)
        })
    }
    
    func updateList(list: ListModel, savedList: ListObject, ignoreCategories: Bool){
        try? realm?.write({
            savedList.name = list.name
            savedList.status = list.status.rawValue
            savedList.totalPrice = list.totalPrice
            savedList.currency = list.currency
            savedList.oldTotalPrice = list.oldTotalPrice
            savedList.totalItems = list.totalItems
            savedList.tickedOffItems = list.tickedOffItems
            savedList.updatedAt = list.updatedAt
            
            if !ignoreCategories {

                deleteListItems(listID: list.id)
                deleteListCategories(listID: list.id)
                
                for category in createCategoryObjects(list: list) {
                    savedList.categories.append(category)
                }
            }
            
        })
    }
    
    func deleteList(listID: Int){
        try? realm?.write({
            let results = realm?.objects(ListObject.self).filter("id = %@", listID)
            if let results = results {
                deleteListItems(listID: listID)
                deleteListCategories(listID: listID)
                
                realm?.delete(results)
            }
        })
    }
    
    func searchLists(query: String) -> [ListModel] {
        if let savedLists = realm?.objects(ListObject.self).filter("name contains[c] %@", query){
            return savedLists.map{ $0.getListModel() }
        }
        
        return []
    }

}

extension ListRealmStore {
    func createListObject(list: ListModel, ignoreCategories: Bool = false) -> ListObject {
        
        if let savedList = getListObject(listID: list.id){
            return savedList
        }
        
        let savedList = ListObject()
        savedList.id = list.id
        savedList.name = list.name
        savedList.status = list.status.rawValue

        savedList.identifier = list.identifier
        savedList.storeTypeID = list.storeTypeID

        savedList.currency = list.currency
        savedList.totalPrice = list.totalPrice
        savedList.oldTotalPrice = list.oldTotalPrice

        savedList.totalItems = list.totalItems
        savedList.tickedOffItems = list.tickedOffItems

        savedList.createdAt = list.createdAt
        savedList.updatedAt = list.updatedAt
        
        if !ignoreCategories {
            savedList.categories.removeAll()
            
            for category in createCategoryObjects(list: list) {
                savedList.categories.append(category)
            }
        }
        
        return savedList
    }
}

extension ListRealmStore {
    func updateListTotalPrice(listID: Int, totalPrice: Double, oldTotalPrice: Double?) {
        if let savedList = getListObject(listID: listID) {
            try? realm?.write({
                savedList.totalPrice = totalPrice
                savedList.oldTotalPrice = oldTotalPrice
            })
        }
    }
    
    func restartList(listID: Int) {
        try? realm?.write({
            let items = realm?.objects(ListItemObject.self).filter("listID = %@", listID)
            
            if let items = items {
                for item in items {
                    item.tickedOff = false
                }
            }
        })
    }
}


extension ListRealmStore {
    private func deleteListItems(listID: Int){
        if let items = realm?.objects(ListItemObject.self).filter("listID = %@", listID) {
            realm?.delete(items)
        }
    }
    
    private func deleteListCategories(listID: Int){
        if let categories = realm?.objects(ListCategoryObject.self).filter("listID = %@", listID) {
            realm?.delete(categories)
        }
    }
    
    private func createCategoryObjects(list: ListModel) -> List<ListCategoryObject> {
        let savedCategories = List<ListCategoryObject>()
        
        for category in list.categories {
            
            let savedCategory = ListCategoryObject()
            
            savedCategory.id = category.id
            savedCategory.name = category.name
            savedCategory.listID = list.id
            
            for item in category.items {
                let savedItem = ListItemObject()
                
                savedItem.id = item.id
                savedItem.name = item.name
                savedItem.image = item.image
                savedItem.price = item.price
                savedItem.listID = list.id
                savedItem.price = item.price
                savedItem.currency = item.currency
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
