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
                listItem!.discount = product.discount?.getRealmObject()
                listItem!.list_id = listId
                listItem!.quantity = product.quantity == 0 ? 1 : product.quantity

                var listCategory = realm.objects(ListCategoryHistory.self).filter("list_id = \(listId) AND id = \(product.parent_category_id!)").first

                print("Category Name: \(product.parent_category_name!)")
                if listCategory != nil {
                    listCategory!.items.append(listItem!)
                } else {
                    listCategory = ListCategoryHistory()
                    listCategory!.id = product.parent_category_id!
                    listCategory!.name = product.parent_category_name!
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
