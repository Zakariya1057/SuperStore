//
//  ProductRealmStore.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import RealmSwift

class ProductRealmStore: DataStore, ProductStoreProtocol {
    
    private var reviewStore: ReviewRealmStore = ReviewRealmStore()
    private var promotionStore: PromotionRealmStore = PromotionRealmStore()
    
    private func getProductObject(productID: Int) -> ProductObject? {
        return realm?.objects(ProductObject.self).filter("id = %@", productID).first
    }
    
    
    func getProduct(productID: Int) -> ProductModel? {
        return getProductObject(productID: productID)?.getProductModel()
    }
    
    func createProducts(products: [ProductModel]){
        for product in products {
            createProduct(product: product)
        }
    }
    
    func createProduct(product: ProductModel) {
        
        if let savedProduct = getProductObject(productID: product.id) {
            updateSavedProduct(product: product, savedProduct: savedProduct)
            return
        }
        
        try? realm?.write({
            let savedProduct = createProductObject(product: product)
            realm?.add(savedProduct)
        })
    }
    
    func updateProductMonitor(productID: Int, monitor: Bool) {
        if let savedProduct = getProductObject(productID: productID) {
            try? realm?.write({
                savedProduct.monitoring = monitor
            })
        }
    }
    
}

extension ProductRealmStore {
    func clearFavourites(){
        let savedFavourites = realm?.objects(ProductObject.self).filter("favourite = %@", true)
        
        try? realm?.write({
            if let savedFavourites = savedFavourites {
                for product in savedFavourites {
                    product.favourite = false
                }
            }
        })
    }
    func updateProductFavourite(productID: Int, favourite: Bool) {
        if let savedProduct = getProductObject(productID: productID) {
            try? realm?.write({
                savedProduct.favourite = favourite
            })
        }
    }
    
    func getFavouriteProducts() -> [ProductModel] {
        return realm?.objects(ProductObject.self).filter("favourite = %@", true).map{ $0.getProductModel() } ?? []
    }
}

extension ProductRealmStore {
    func createProductObject(product: ProductModel) -> ProductObject {
        
        if let savedProduct = getProductObject(productID: product.id) {
            return savedProduct
        }
        
        let savedProduct = ProductObject()
        
        savedProduct.id = product.id
        savedProduct.name = product.name
        savedProduct.price = product.price
        
        if let promotion = product.promotion {
            savedProduct.promotion = promotionStore.createPromotionObject(promotion: promotion)
        }
        
        let recommended = List<ProductObject>()
        for product in product.recommended {
            recommended.append( createProductObject(product: product) )
        }
        
        savedProduct.recommended = recommended
        
        savedProduct.smallImage = product.smallImage
        savedProduct.largeImage = product.largeImage
        
        savedProduct.productDescription = product.description
        
        savedProduct.favourite = product.favourite
        savedProduct.monitoring = product.monitoring
        
        savedProduct.avgRating = product.avgRating
        savedProduct.totalReviewsCount = product.totalReviewsCount
        
        let parentCategoryID = RealmOptional<Int>()
        parentCategoryID.value = 1
        
        savedProduct.parentCategoryID = parentCategoryID
        savedProduct.parentCategoryName = product.parentCategoryName
        savedProduct.childCategoryName = product.childCategoryName
        
        savedProduct.storage = product.storage
        savedProduct.weight = product.weight
        savedProduct.brand = product.brand
        
        savedProduct.dietaryInfo = product.dietaryInfo
        savedProduct.allergenInfo = product.allergenInfo
        
        let reviews = List<ReviewObject>()
        
        for review in product.reviews {
            reviews.append( reviewStore.createReviewObject(review: review) )
        }
        
        savedProduct.reviews = reviews
        
        let ingredients = List<String>()
        product.ingredients.forEach { (ingredient: String) in
            ingredients.append(ingredient)
        }
        
        savedProduct.ingredients = ingredients
        
        return savedProduct
    }
    
}

extension ProductRealmStore {
    func updateSavedProduct(product: ProductModel, savedProduct: ProductObject){
        try? realm?.write({
            savedProduct.id = product.id
            savedProduct.name = product.name
            savedProduct.price = product.price
            
            updatePromotion(product: product, savedProduct: savedProduct)
            
            updateRecommended(product: product, savedProduct: savedProduct)
            
            updateImage(product: product, savedProduct: savedProduct)
            
            savedProduct.productDescription = product.description
            
            savedProduct.favourite = product.favourite
            savedProduct.monitoring = product.monitoring
            
            updateRatings(product: product, savedProduct: savedProduct)
            
            updateParentCategory(product: product, savedProduct: savedProduct)

            if product.childCategoryName != nil {
                savedProduct.childCategoryName = product.childCategoryName
            }
            
            savedProduct.storage = product.storage
            savedProduct.weight = product.weight
            savedProduct.brand = product.brand
            
            savedProduct.dietaryInfo = product.dietaryInfo
            savedProduct.allergenInfo = product.allergenInfo
            
            updateReviews(product: product, savedProduct: savedProduct)

            updateIngredients(product: product, savedProduct: savedProduct)

        })
    }

}

extension ProductRealmStore {
    
    func updateRatings(product: ProductModel, savedProduct: ProductObject){
        savedProduct.avgRating = product.avgRating
        savedProduct.totalReviewsCount = product.totalReviewsCount
    }
    
    func updateImage(product: ProductModel, savedProduct: ProductObject){
        savedProduct.smallImage = product.smallImage
        savedProduct.largeImage = product.largeImage
    }
    
    func updatePromotion(product: ProductModel, savedProduct: ProductObject){
        if let promotion = product.promotion {
            savedProduct.promotion = promotionStore.createPromotionObject(promotion: promotion)
        }
    }
    
    func updateParentCategory(product: ProductModel, savedProduct: ProductObject){
        
        if product.parentCategoryName != nil {
            savedProduct.parentCategoryName = product.parentCategoryName
        }
        
        if product.parentCategoryID != nil {
            let parentCategoryID = RealmOptional<Int>()
            parentCategoryID.value = 1
            
            savedProduct.parentCategoryID = parentCategoryID
        }
    }
    
    func updateRecommended(product: ProductModel, savedProduct: ProductObject){
        if product.recommended.count > 0 {
            let recommended = List<ProductObject>()
            
            for product in product.recommended {
                recommended.append( createProductObject(product: product) )
            }
            
            savedProduct.recommended.removeAll()
            savedProduct.recommended = recommended
        }
    }
    
    func updateIngredients(product: ProductModel, savedProduct: ProductObject){
        if product.ingredients.count > 0 {
            let ingredients = List<String>()
            
            product.ingredients.forEach { (ingredient: String) in
                ingredients.append(ingredient)
            }
            
            savedProduct.ingredients.removeAll()
            savedProduct.ingredients = ingredients
        }
    }
    
    func updateReviews(product: ProductModel, savedProduct: ProductObject){
        if product.reviews.count > 0 {
            let reviews = List<ReviewObject>()
            
            for review in product.reviews {
                reviews.append( reviewStore.createReviewObject(review: review) )
            }
            
            savedProduct.reviews.removeAll()
            savedProduct.reviews = reviews
        }
    }
}
