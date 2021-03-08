//
//  ListItemRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListItemRealmStore: DataStore {
    
    func getListItem(itemID: Int) -> ListItemModel? {
        if let savedList = realm?.objects(ListItemObject.self).filter("id = %@", itemID).first {
            return savedList.getListItemModel()
        }
        
        return nil
    }
}
