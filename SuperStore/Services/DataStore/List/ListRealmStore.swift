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

    lazy var userSession = UserSessionWorker()
    lazy var listItemStore: ListItemRealmStore = ListItemRealmStore()
    
    var listPriceWorker = ListPriceWorker()
    
    func getListObject(listID: Int) -> ListObject? {
        return realm?.objects(ListObject.self).filter("deleted = false AND id = %@", listID).first
    }
    
    
    func getDeletedListObject(listID: Int) -> ListObject? {
        return realm?.objects(ListObject.self).filter("deleted = true AND id = %@", listID).first
    }
    
    func getEditedListObject(listID: Int) -> ListObject? {
        return realm?.objects(ListObject.self).filter("edited = true AND id = %@", listID).first
    }
    
    
    func getListCategory(categoryID: Int) -> ListCategoryObject? {
        return realm?.objects(ListCategoryObject.self).filter("deleted = false AND id = %@", categoryID).first
    }
    
    func getList(listID: Int) -> ListModel? {
        
        if let savedList = getListObject(listID: listID) {
            return savedList.getListModel()
        }
        
        return nil
    }
    
    func getLists(storeTypeID: Int) -> [ListModel] {
        var lists: [ListModel] = []
        
        let savedLists = realm?.objects(ListObject.self).filter("deleted = false AND storeTypeID = %@", storeTypeID).sorted(byKeyPath: "updatedAt", ascending: false)
        
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
            
            setOldTotalPrice(savedList: savedList, oldTotalPrice: list.oldTotalPrice)
            
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
    
    func deleteList(listID: Int, offline: Bool = false){
        try? realm?.write({
            let results = realm?.objects(ListObject.self).filter("id = %@", listID)
            if let results = results {
                
                deleteListItems(listID: listID)
                deleteListCategories(listID: listID)
                
                if offline {
                    if let list = results.first {
                        list.deleted = true
                    }
                } else {
                    realm?.delete(results)
                }
            }
        })
    }
    
    func searchLists(storeTypeID: Int, query: String) -> [ListModel] {
        let savedLists = realm?.objects(ListObject.self)
            .filter("deleted = false AND storeTypeID = %@ AND name contains[c] %@",storeTypeID, query)
            .sorted(byKeyPath: "updatedAt", ascending: false)
        
        if let savedLists = savedLists {
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
        
        savedList.edited = false

        savedList.identifier = list.identifier
        savedList.storeTypeID = list.storeTypeID

        savedList.currency = list.currency
        savedList.totalPrice = list.totalPrice
        
        setOldTotalPrice(savedList: savedList, oldTotalPrice: list.oldTotalPrice)

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
    func updateListTotalPrice(listID: Int) {
        
        let items = listItemStore.getListItems(listID: listID)
        
        let (totalPrice, oldTotalPrice) = listPriceWorker.calculateListPrice(items: items)
        
        if let savedList = getListObject(listID: listID) {
            try? realm?.write({
                savedList.totalPrice = totalPrice
                setOldTotalPrice(savedList: savedList, oldTotalPrice: oldTotalPrice)
            })
        }
    }
    
    func listEdited(listID: Int){
        try? realm?.write({
            
            if let savedList = getListObject(listID: listID) {
                if !userSession.isOnline() {
                    savedList.edited = true
                }
                
                // Update total ticked off items count
                let items = savedList.categories.flatMap { (category: ListCategoryObject)  in
                    return category.items
                }
                
                savedList.totalItems = items.count
                
                savedList.tickedOffItems = items.filter({ (listItem: ListItemObject) -> Bool in
                    return listItem.tickedOff
                }).count
                
                setListStatus(savedList: savedList)
                
                savedList.updatedAt = Date()
            }
        })
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
    func setOldTotalPrice(savedList: ListObject, oldTotalPrice: Double?){
        let listOldTotalPrice = RealmOptional<Double>()
        
        if oldTotalPrice != nil {
            listOldTotalPrice.value = oldTotalPrice!
        }
        
        savedList.oldTotalPrice = listOldTotalPrice
    }
    
    func setListStatus(savedList: ListObject){
        if savedList.totalItems == 0 || savedList.tickedOffItems == 0 {
            savedList.status = ListStatus.notStarted.rawValue
        } else if savedList.tickedOffItems == savedList.totalItems {
            savedList.status = ListStatus.completed.rawValue
        } else if savedList.tickedOffItems > 0 {
            savedList.status = ListStatus.inProgress.rawValue
        }
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
                let savedItem = listItemStore.createListItemObject(listItem: item, listID: list.id)
                savedCategory.items.append(savedItem)
            }
            
            savedCategories.append(savedCategory)
        }
        
        return savedCategories
    }
}

extension ListRealmStore {
    func isDeletedList(listID: Int) -> Bool {
        return getDeletedListObject(listID: listID) != nil
    }
    
    func isEditedList(listID: Int) -> Bool {
        return getEditedListObject(listID: listID) != nil
    }
    
    
    func getDeletedLists() -> [ListModel] {
        return realm?.objects(ListObject.self).filter("deleted = true").map { $0.getListModel() } ?? []
    }
    
    func getEditedLists() -> [ListModel] {
        return realm?.objects(ListObject.self).filter("deleted = false AND edited = true").map { $0.getListModel() } ?? []
    }
    
    
    func syncList(listID: Int){
        if let savedList = getListObject(listID: listID){
            
            try? realm?.write({
                savedList.edited = false
            })
            
        }
    }
}
