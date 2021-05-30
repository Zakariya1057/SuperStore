//
//  ListPriceWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 05/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation

class ListPriceWorker {
    
    func calculateItemPrice(listItem: ListItemModel, includeMaxCalculation: Bool = true) -> Double {
        var price:Double = 0
        
        let quantity = listItem.quantity
        let itemPrice = listItem.price
        let promotion = listItem.promotion
        
        if promotion == nil ||
            (
            promotion!.quantity == nil && promotion!.minimum == nil &&
            (!includeMaxCalculation || includeMaxCalculation && promotion!.maximum == nil)
        )
        {
            price = ( Double(quantity) * itemPrice)
        } else {
            
            if let promotion = promotion {
                
                if let minimum = promotion.minimum {
                    if quantity >= minimum {
                        price = ( Double(quantity) * promotion.price! )
                    } else {
                        price = ( Double(quantity) * itemPrice )
                    }
                }
                else if includeMaxCalculation, let maximum = promotion.maximum {
                    for i in 0..<quantity {
                        if i < maximum {
                            price += promotion.price!
                        } else {
                            price += itemPrice
                        }
                    }
                }
                else {
                    if let promotionQuantity = promotion.quantity {
                        
                        let remainder = (quantity % promotionQuantity)
                        let goesIntoFully = floor(Double(Int(quantity) / Int(promotionQuantity)))
                        
                        if quantity < promotionQuantity {
                            price = Double(quantity) * itemPrice
                        } else {
                            if promotion.forQuantity != nil && promotion.forQuantity! > 0{
                                price = (Double(goesIntoFully) * (Double(promotion.forQuantity!) * itemPrice) ) + (Double(remainder) * itemPrice)
                            } else if (promotion.price != nil){
                                price = (Double(goesIntoFully) * promotion.price!) + (Double(remainder) * itemPrice)
                            }
                        }

                    }
                    
                }
                
            }

        }
        
        return price
    }
       
    func calculateListPrice(items: [ListItemModel]) -> (Double, Double?){

        var totalPrice: Double = 0.00
        var priceNoPromotion: Double = 0.00
        var oldTotalPrice: Double = 0.00
        var totalPriceWithoutPromotionItems: Double = 0.0

        // Group products by promotion
        var promotions = [Int: Dictionary<String, [Any]>]()

        for product in items {

            for _ in 1...product.quantity {
                
                let itemPrice = product.price
                
                if let promotion = product.promotion {
                    if promotion.quantity != nil || promotion.minimum != nil || promotion.maximum != nil {
                        if let _ = promotions[product.promotion!.id] {
                            promotions[promotion.id]!["items"]!.append(product)
                        } else {
                            promotions[promotion.id] = ["items": [product], "promotion": [product.promotion!]]
                        }
                    } else {
                        totalPriceWithoutPromotionItems += itemPrice
                    }
                } else {
                    totalPriceWithoutPromotionItems += itemPrice
                }
                
                totalPrice += calculateItemPrice(listItem: product, includeMaxCalculation: false)
                priceNoPromotion += itemPrice
                
            }
        }

        var promotionTotalPrice: Double = 0
        
        
        for promotion in promotions {
            let items = promotion.value["items"] as! [ListItemModel]
            let promotion = promotion.value["promotion"]![0] as! PromotionModel

            let totalQuantity = items.count
            var totalItemsPrice: Double = 0
            
            for product in items {
                totalItemsPrice += product.price
            }
            
            if let promotionQuantity = promotion.quantity {
                
                // Calculate Product Promotion By Group.
                if totalQuantity >= promotionQuantity {

                    var highestPrice: Double = 0

                    for product in items {
                        if product.price > highestPrice {
                            highestPrice = product.price
                        }
                    }

                    let remainder = (totalQuantity % promotionQuantity)
                    let goesIntoFully = floor(Double(totalQuantity) / Double(promotionQuantity))

                    var newTotal: Double = 0

                    if promotion.forQuantity != nil && promotion.forQuantity! > 0 {
                        newTotal = (Double(goesIntoFully) * (Double(promotion.forQuantity!) * highestPrice) ) + (Double(remainder) * highestPrice)
                    } else if (promotion.price != nil && promotion.price! > 0){
                        newTotal = (Double(goesIntoFully) * promotion.price!) + (Double(remainder) * highestPrice)
                    }

                    promotionTotalPrice += newTotal

                } else {
                    promotionTotalPrice += totalItemsPrice
                }
                
            } else if let promotionMinimumQuantity = promotion.minimum {
                if(totalQuantity >= promotionMinimumQuantity){
                    promotionTotalPrice += Double(totalQuantity) * promotion.price!
                } else {
                    promotionTotalPrice += totalItemsPrice
                }
            } else if let promotionMaximumQuantity = promotion.maximum {
                for (index, product) in items.enumerated() {
                    if index < promotionMaximumQuantity {
                        promotionTotalPrice += promotion.price!
                    } else {
                        promotionTotalPrice += product.price
                    }
                }
            } else {
                promotionTotalPrice += totalItemsPrice
            }
        }
        
        if promotionTotalPrice < totalPrice {
            totalPrice = totalPriceWithoutPromotionItems + promotionTotalPrice
            oldTotalPrice = priceNoPromotion
        }
        
        return (totalPrice, oldTotalPrice == 0 ? nil : oldTotalPrice)
    }
}
