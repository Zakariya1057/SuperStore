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
    
    let realm = try! Realm()
    
    func addProductToList(listId: Int, product: ProductModel) -> ListItemHistory {

        var listItem = realm.objects(ListItemHistory.self).filter("list_id = \(listId) AND product_id = \(product.id)").first

        try! realm.write() {

            if listItem == nil {
                listItem = ListItemHistory()

                print("Product Creating List Item Quantity")

                listItem!.product_id = product.id
                listItem!.name = product.name
                listItem!.image = product.image
                listItem!.price = product.price
                listItem!.promotion = product.promotion?.getRealmObject()
                listItem!.list_id = listId
                listItem!.quantity = product.quantity == 0 ? 1 : product.quantity

                var listCategory = realm.objects(ListCategoryHistory.self).filter("list_id = \(listId) AND id = \(product.parentCategoryId!)").first

                print("Category Name: \(product.parentCategoryName!)")
                if listCategory != nil {
                    listCategory!.items.append(listItem!)
                } else {
                    listCategory = ListCategoryHistory()
                    listCategory!.id = product.parentCategoryId!
                    listCategory!.name = product.parentCategoryName!
                    listCategory!.list_id = listId
                    listCategory!.items.append(listItem!)

                    let list = realm.objects(ListHistory.self).filter("id = \(listId)").first

                    list!.categories.append(listCategory!)
                }
            } else {
                // Update list item Instead Of Creating
                print("Product Item Found. Updating Instead")
            }
            
        }
        
        return listItem!
    }
    
    func updateProduct(listId: Int, product: ProductModel){
        
        var item = realm.objects(ListItemHistory.self).filter("list_id = \(listId) AND product_id = \(product.id)").first
        
        if item == nil {
            print("list_id = \(listId) AND product_id = \(product.id)")
            print("Error: No List Item Found. Adding It")
            
            item = addProductToList(listId: listId, product: product)
        }
        
        if(product.quantity == 0){
            removeProductFromList(listId: listId,product: nil,item: item)
        } else {
            try! realm.write() {
                print("Product Updating List Item Quantity")
                item!.quantity = product.quantity
            }

        }

    }
    
    func removeProductFromList(listId: Int, product: ProductModel?, item: ListItemHistory? = nil){
        try! realm.write() {
            if item == nil {
                realm.delete(realm.objects(ListItemHistory.self).filter("list_id = \(listId) AND product_id = \(product!.id)"))
            } else {
                realm.delete(item!)
            }
        }
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
