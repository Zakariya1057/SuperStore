//
//  ListRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
    
class ListRealmStore: DataStore, ListStoreProtocol {

    func getList(listID: Int) -> ListModel? {
        
        if let savedList = realm?.objects(ListObject.self).filter("id = %@", listID).first {
            return savedList.getListModel()
        }
        
        return nil
    }
    
    func createList(list: ListModel){
        
        let duplicateList = getList(listID: list.id)
        
        if duplicateList != nil {
            print("List already created. Updating instead.")
            updateList(list: list)
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

            realm?.add(savedList)

        })
    }
    
    func updateList(list: ListModel){
        
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
