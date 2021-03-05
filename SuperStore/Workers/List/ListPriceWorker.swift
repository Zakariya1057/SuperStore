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
    
//    func calculateItemPrice(price itemPrice: Double, quantity: Int, promotion: PromotionModel?) -> Double {
//        var price:Double = 0
//
//        if promotion == nil {
//            price = ( Double(quantity) * itemPrice)
//        } else {
//
//            let promotion = promotion
//
//            let remainder = (quantity % promotion!.quantity)
//            let goesIntoFully = floor(Double(Int(quantity) / Int(promotion!.quantity)))
//
//            if quantity < promotion!.quantity {
//                price = Double(quantity) * itemPrice
//            } else {
//                if promotion!.forQuantity != nil && promotion!.forQuantity! > 0{
//                    price = (Double(goesIntoFully) * (Double(promotion!.forQuantity!) * itemPrice) ) + (Double(remainder) * itemPrice)
//                } else if (promotion!.price != nil){
//                    price = (Double(goesIntoFully) * promotion!.price!) + (Double(remainder) * itemPrice)
//                }
//            }
//
//        }
//
//        return price
//    }
    
    func calculateItemPrice(listItem: ListItemModel) -> Double {
        var price:Double = 0

        let quantity = listItem.quantity
        let itemPrice = listItem.price
        let promotion = listItem.promotion
        
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
        
    
    func calculateListPrice(items: [ListItemModel]) -> (Double, Double?){

        var totalPrice: Double = 0.00
        var priceNoPromotion: Double = 0.00
        var oldTotalPrice: Double = 0.00

        // Group products by promotion
        var promotions = [Int: Dictionary<String, [Any]>]()

        for product in items {

            if product.promotion != nil {
                if let _ = promotions[product.promotion!.id] {
                    promotions[product.promotion!.id]!["items"]!.append(product)
                } else {
                    promotions[product.promotion!.id] = ["items": [product], "promotion": [product.promotion!]]
                }
            }

            totalPrice += calculateItemPrice(listItem: product)
            priceNoPromotion += ( Double(product.quantity) * product.price)
        }

        for promotion in promotions {
            let items = promotion.value["items"] as! [ListItemModel]
            let promotion = promotion.value["promotion"]![0] as! PromotionModel
            var newTotalPrice: Double = 0

            var totalQuantity = 0

            for product in items {
                totalQuantity += product.quantity
            }

            // Calculate Product Promotion By Group.
            if totalQuantity >= promotion.quantity {

                var highestPrice: Double = 0
                var previousTotalPrice: Double = 0

                for product in items {
                    previousTotalPrice = previousTotalPrice + calculateItemPrice(listItem: product)

                    if product.price > highestPrice {
                        highestPrice = product.price
                    }
                }

                let remainder = (totalQuantity % promotion.quantity)
                let goesIntoFully = floor(Double(totalQuantity) / Double(promotion.quantity))

                var newTotal: Double = 0

                if promotion.forQuantity != nil && promotion.forQuantity! > 0 {
                    newTotal = (Double(goesIntoFully) * (Double(promotion.forQuantity!) * highestPrice) ) + (Double(remainder) * highestPrice)
                } else if (promotion.price != nil && promotion.price! > 0){
                    newTotal = (Double(goesIntoFully) * promotion.price!) + (Double(remainder) * highestPrice)
                }

                newTotalPrice = (totalPrice - previousTotalPrice) + newTotal

                if newTotalPrice != totalPrice && totalPrice > newTotalPrice {
                    oldTotalPrice = priceNoPromotion
                    totalPrice = newTotalPrice
                }

            }

        }
        
        return (totalPrice, oldTotalPrice == 0 ? nil : oldTotalPrice)
    }
}
