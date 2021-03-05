//
//  ListPriceWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListPriceWorker {
    // Calculate price using promotion.
    // Calculate item price and list price.
    
    func calculateItemPrice(price itemPrice: Double, quantity: Int, promotion: PromotionModel?) -> Double {
        var price:Double = 0

        if promotion == nil {
            price = ( Double(quantity) * itemPrice)
        } else {

            let promotion = promotion

            let remainder = (quantity % promotion!.quantity)
            let goesIntoFully = floor(Double(Int(quantity) / Int(promotion!.quantity)))

            if quantity < promotion!.quantity {
                price = Double(quantity) * itemPrice
            } else {
                if promotion!.forQuantity != nil && promotion!.forQuantity! > 0{
                    price = (Double(goesIntoFully) * (Double(promotion!.forQuantity!) * itemPrice) ) + (Double(remainder) * itemPrice)
                } else if (promotion!.price != nil){
                    price = (Double(goesIntoFully) * promotion!.price!) + (Double(remainder) * itemPrice)
                }
            }

        }

        return price
    }
    
    //    func calculateProductPrice(_ product: ProductItemModel) -> Double {
    //        var price:Double = 0
    //
    //        if product.promotion == nil {
    //            price = ( Double(product.quantity) * product.price)
    //        } else {
    //
    //            let promotion = product.promotion
    //
    //            let remainder = (product.quantity % promotion!.quantity)
    //            let goesIntoFully = floor(Double(Int(product.quantity) / Int(promotion!.quantity)))
    //
    //            if product.quantity < promotion!.quantity {
    //                price = Double(product.quantity) * product.price
    //            } else {
    //                if promotion!.forQuantity != nil && promotion!.forQuantity! > 0{
    //                    price = (Double(goesIntoFully) * (Double(promotion!.forQuantity!) * product.price) ) + (Double(remainder) * product.price)
    //                } else if (promotion!.price != nil){
    //                    price = (Double(goesIntoFully) * promotion!.price!) + (Double(remainder) * product.price)
    //                }
    //            }
    //
    //        }
    //
    //        return price
    //    }
}
