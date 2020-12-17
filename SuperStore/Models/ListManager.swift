//
//  ListManager.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 16/10/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

struct ListManager {
    
    var listHandler = ListsHandler()
    
    let realm = try! Realm()
    
    func addProductToList(listID: Int, product: ProductModel) -> ListItemHistory {

        var listItem = realm.objects(ListItemHistory.self).filter("listID = \(listID) AND productID = \(product.id)").first

        try! realm.write() {

            if listItem == nil {
                listItem = ListItemHistory()

                print("Product Creating List Item Quantity")

                listItem!.productID = product.id
                listItem!.name = product.name
                listItem!.image = product.largeImage
                listItem!.price = product.price
                listItem!.weight = product.weight ?? ""
                listItem!.promotion = product.promotion?.getRealmObject()
                listItem!.listID = listID
                listItem!.quantity = product.quantity == 0 ? 1 : product.quantity

                var listCategory = realm.objects(ListCategoryHistory.self).filter("listID = \(listID) AND id = \(product.parentCategoryId!)").first

                print("Category Name: \(product.parentCategoryName!)")
                if listCategory != nil {
                    listCategory!.items.append(listItem!)
                } else {
                    listCategory = ListCategoryHistory()
                    listCategory!.id = product.parentCategoryId!
                    listCategory!.name = product.parentCategoryName!
                    listCategory!.listID = listID
                    listCategory!.items.append(listItem!)

                    let list = realm.objects(ListHistory.self).filter("id = \(listID)").first
                    
                    if list!.totalItems > 0 && list!.categories.count == 0 {
                        // List not loaded, when online append to current list.
                        list!.mode = "append"
                    }
                    
                    list!.categories.append(listCategory!)
                }
                
//                listReflectChanges(listID: listID)
            } else {
                // Update list item Instead Of Creating
                print("Product Item Found. Updating Instead")
            }
            
        }
        
        return listItem!
    }
    
    func updateProduct(listID: Int, product: ProductModel){
        
        var item = realm.objects(ListItemHistory.self).filter("listID = \(listID) AND productID = \(product.id)").first
        
        if item == nil {
            print("listID = \(listID) AND productID = \(product.id)")
            print("Error: No List Item Found. Adding It")
            
            item = addProductToList(listID: listID, product: product)
        }
        
        if(product.quantity == 0){
            removeProductFromList(listID: listID,product: nil,item: item)
        } else {
            try! realm.write() {
                print("Product Updating List Item Quantity")
                item!.quantity = product.quantity
//                listReflectChanges(listID: listID)
            }

        }

    }
    
    func removeProductFromList(listID: Int, product: ProductModel?, item: ListItemHistory? = nil){
        try! realm.write() {
            if item == nil {
                realm.delete(realm.objects(ListItemHistory.self).filter("listID = \(listID) AND productID = \(product!.id)"))
            } else {
                realm.delete(item!)
            }
            
//            listReflectChanges(listID: listID)
            
        }
        
    }
    
    func listReflectChanges(listID: Int){
        // Update list items checked, totals
        
//        try! realm.write() {
            let list = realm.objects(ListHistory.self).filter("id = \(listID)").first
            
            if list != nil {
                print("Updating List Details.")
                let items = realm.objects(ListItemHistory.self).filter("listID = \(listID)")
                
                list?.totalItems = items.count
                list?.tickedOffItems = items.filter("tickedOff = true").count
                
                var total: Double = 0
                
                for item in items {
                    total = total + calculateProductPrice(item.getItemModel())
                }
                
                list?.totalPrice = total
                
            } else {
                print("No List Found: \(listID)")
            }
//        }
        
    }
    
}

extension ListManager {
    
    func calculateProductPrice(_ product: ProductItemModel) -> Double {
        var price:Double = 0
        
        if product.promotion == nil {
            price = ( Double(product.quantity) * product.price)
        } else {
            
            let promotion = product.promotion

            let remainder = (product.quantity % promotion!.quantity)
            let goesIntoFully = floor(Double(Int(product.quantity) / Int(promotion!.quantity)))
            
            if product.quantity < promotion!.quantity {
                price = Double(product.quantity) * product.price
            } else {
                if promotion!.forQuantity != nil && promotion!.forQuantity! > 0{
                    price = (Double(goesIntoFully) * (Double(promotion!.forQuantity!) * product.price) ) + (Double(remainder) * product.price)
                } else if (promotion!.price != nil){
                    price = (Double(goesIntoFully) * promotion!.price!) + (Double(remainder) * product.price)
                }
            }
            
        }
        
        return price
    }
    
}

extension ListManager {
    
    func getListItems(_ listHistory: ListHistory) -> [[String : String]] {
        var items:[[String: String]] = []
        
        for category in listHistory.categories {
            for product in category.items {
                items.append([
                    "product_id": String(product.productID),
                    "quantity": String(product.quantity),
                    "ticked_off": String(product.tickedOff)
                ])
            }
        }
        
        return items
    }
    
    
    func uploadEditedList(listHistory: ListHistory){
        // List edited:
        // Update name
        // Update/Insert All Items
        
        let items = getListItems(listHistory)
        
        listHandler.update(list_data: [
            "identifier": listHistory.identifier,
            "name": listHistory.name,
            "store_type_id": "1",
            "items": items,
            "mode": listHistory.deleted ? "delete" : "overwrite"
        ])
        
        listHistory.edited = false
        listHistory.mode = "overwrite"
    }
    
}
