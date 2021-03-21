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
    private lazy var promotionStore: PromotionRealmStore = PromotionRealmStore()
    
    private func getProductObject(productID: Int) -> ProductObject? {
        return realm?.objects(ProductObject.self).filter("id = %@", productID).first
    }
    
    
    func getProduct(productID: Int) -> ProductModel? {
        
        if let productObject = getProductObject(productID: productID) {
            let product = productObject.getProductModel()
            
            if let promotionID = productObject.promotionID.value {
                let promotion: PromotionModel? = promotionStore.getPromotion(promotionID: promotionID)
                
                if let promotion = promotion {
                    if promotionExpired(promotion: promotion){
                        deleteProductPromotion(productID: product.id, promotionID: promotion.id)
                    }
                }
                
                product.promotion = promotion
                
            }
            
            return product
        }
        
        return nil
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
    func deleteProductPromotion(productID: Int, promotionID: Int){
        if let savedProduct = getProductObject(productID: productID){
            if let inWrite = realm?.isInWriteTransaction, inWrite {
                savedProduct.promotionID.value = nil
            } else {
                try? realm?.write({
                    savedProduct.promotionID.value = nil
                })
            }
        }
        
        promotionStore.deletePromotion(promotionID: promotionID)
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
        
        savedProduct.largeImage = product.largeImage
        savedProduct.smallImage = product.smallImage
        
        savedProduct.storeTypeID = product.storeTypeID
        
        savedProduct.id = product.id
        savedProduct.name = product.name
        
        savedProduct.price = product.price
        updateOldTotalPrice(product: product, savedProduct: savedProduct)
        
        savedProduct.saleEndsAt = product.saleEndsAt
        
        savedProduct.currency = product.currency
        
        createPromotion(product: product, savedProduct: savedProduct)
        
        for product in product.recommended {
            savedProduct.recommended.append( createProductObject(product: product) )
        }
        
        for image in product.images {
            savedProduct.images.append( createImageObject(image: image) )
        }
        
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
        
        for review in product.reviews {
            savedProduct.reviews.append( reviewStore.createReviewObject(review: review) )
        }
        
        product.ingredients.forEach { (ingredient: String) in
            savedProduct.ingredients.append(ingredient)
        }
        
        savedProduct.updatedAt = Date()
        
        return savedProduct
    }
    
    func createImageObject(image: ImageModel) -> ImageObject {
        let savedImage = ImageObject()
        savedImage.productID = image.productID
        savedImage.name = image.name
        savedImage.size = image.size
        
        return savedImage
    }
    
}

extension ProductRealmStore {
    func updateSavedProduct(product: ProductModel, savedProduct: ProductObject){
        try? realm?.write({
            savedProduct.id = product.id
            savedProduct.name = product.name
            
            savedProduct.storeTypeID = product.storeTypeID
            
            savedProduct.price = product.price
            updateOldTotalPrice(product: product, savedProduct: savedProduct)
            
            savedProduct.saleEndsAt = product.saleEndsAt
            
            savedProduct.currency = product.currency
            
            updatePromotion(product: product, savedProduct: savedProduct)
            
            updateRecommended(product: product, savedProduct: savedProduct)
            
            updateImages(product: product, savedProduct: savedProduct)
            
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
    
    func createPromotion(product: ProductModel, savedProduct: ProductObject){
        // If promotion already expired, don't insert that
        
        if let promotion = product.promotion {
            print("Create Promtion")
            
            if !promotionExpired(promotion: promotion) {
                savedProduct.promotion = promotionStore.createPromotionObject(promotion: promotion)
                savedProduct.promotionID.value = promotion.id
            }
        }
    }
    
    func updatePromotion(product: ProductModel, savedProduct: ProductObject){
        if let promotion = product.promotion {
            if promotionExpired(promotion: promotion) {
                // If present locally, then delete
                print("Delete Old Promotion")
                if savedProduct.promotionID.value != nil {
                    promotionStore.deletePromotion(promotionID: savedProduct.promotionID.value!)
                    savedProduct.promotionID.value = nil
                }
            } else {
                print("Store New Promotion")
                savedProduct.promotion = promotionStore.createPromotionObject(promotion: promotion)
                savedProduct.promotionID.value = promotion.id
            }
        } else {
            print("Delete Old Promotion")
            if savedProduct.promotionID.value != nil {
                promotionStore.deletePromotion(promotionID: savedProduct.promotionID.value!)
                savedProduct.promotionID.value = nil
            }
        }
    }
    
    func promotionExpired(promotion: PromotionModel) -> Bool {
        var expired: Bool = false
        
        if let endsAt = promotion.endsAt, ( endsAt < Date() && !Calendar.current.isDate(Date(), inSameDayAs: endsAt) ) {
           expired = true
        }
        
        return expired
    }
}

extension ProductRealmStore {
        
    func updateOldTotalPrice(product: ProductModel, savedProduct: ProductObject){
        let oldPrice = RealmOptional<Double>()
        let isOnSale = RealmOptional<Bool>()
        
        if product.oldPrice != nil {
            oldPrice.value = product.oldPrice!
            isOnSale.value = true
        }
        
        savedProduct.oldPrice = oldPrice
        savedProduct.isOnSale = isOnSale
    }
    
    func updateRatings(product: ProductModel, savedProduct: ProductObject){
        savedProduct.avgRating = product.avgRating
        savedProduct.totalReviewsCount = product.totalReviewsCount
    }
    
    func updateImages(product: ProductModel, savedProduct: ProductObject){
        savedProduct.images.removeAll()
        for image in product.images {
            
            let savedImage = ImageObject()
            savedImage.productID = image.productID
            savedImage.name = image.name
            savedImage.size = image.size
            
            savedProduct.images.append(savedImage)
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
            savedProduct.recommended.removeAll()
            for product in product.recommended {
                savedProduct.recommended.append( createProductObject(product: product) )
            }
            
        }
    }
    
    func updateIngredients(product: ProductModel, savedProduct: ProductObject){
        if product.ingredients.count > 0 {
            
            savedProduct.ingredients.removeAll()
            product.ingredients.forEach { (ingredient: String) in
                savedProduct.ingredients.append(ingredient)
            }
            
        }
    }
    
    func updateReviews(product: ProductModel, savedProduct: ProductObject){
        if product.reviews.count > 0 {
            
            savedProduct.reviews.removeAll()
            for review in product.reviews {
                savedProduct.reviews.append( reviewStore.createReviewObject(review: review) )
            }
            
        }
    }
}
