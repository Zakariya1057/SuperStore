//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Alamofire

protocol SearchSuggestionsDelegate {
    func contentLoaded(suggestions: [SearchModel])
    func errorHandler(_ message:String)
    func logOutUser()
}

protocol SearchResultsDelegate {
    func contentLoaded(stores: [StoreModel], products: [ProductModel], paginate: PaginateResultsModel?)
    func errorHandler(_ message:String)
    func logOutUser()
}

struct SearchHandler {
    
    var suggestionsDelegate: SearchSuggestionsDelegate?
    var resultsDelegate: SearchResultsDelegate?
    
    let requestHandler = RequestHandler()
    
    var day_of_week: Int {
        var day_of_week = Calendar.current.component(.weekday, from: Date()) - 2
        
        if day_of_week == -1 {
            day_of_week = 6
        }
        
        return day_of_week
    }
    
    func requestSuggestions(query: String){
        let hostURL = K.Host
        let suggestionsPath = K.Request.Search.Suggestions
        let urlString = "\(hostURL)/\(suggestionsPath)/\(query)"
        requestHandler.getRequest(url: urlString, complete: processSuggestionsResults,error:processError,logOutUser: logOutUser)
    }
    
    func requestResults(searchData: Parameters, page: Int = 1){
        let hostURL = K.Host
        let resultsPath = K.Request.Search.Results
        let urlString = "\(hostURL)/\(resultsPath)?page=\(page)"
        requestHandler.postRequest(url: urlString, data: searchData, complete: processResults, error: processError,logOutUser: logOutUser)
    }
    
    func processSuggestionsResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let decodedSuggestionsData = try decoder.decode(SearchSuggestionsDataResponse.self, from: data)
            let suggestionsTypes = decodedSuggestionsData.data
            
            var suggestions: [SearchModel] = []
            
            for store in suggestionsTypes.stores {
                suggestions.append(SearchModel(id: store.id, name: store.name, type: .store))
            }
            
            for parentCategory in suggestionsTypes.parent_categories {
                suggestions.append(SearchModel(id: parentCategory.id, name: parentCategory.name, type: .parentCategory))
            }
            
            for childCategory in suggestionsTypes.child_categories {
                suggestions.append(SearchModel(id: childCategory.id, name: childCategory.name, type: .childCategory))
            }
            
            for product in suggestionsTypes.products {
                suggestions.append(SearchModel(id: product.id, name: product.name, type: .product))
            }
            
            DispatchQueue.main.async {
                self.suggestionsDelegate?.contentLoaded(suggestions: suggestions)
            }
        
        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processResults(_ data:Data){
        
        do {
            
            let decoder = JSONDecoder()
            let decodedResultsData = try decoder.decode(SearchResultsDataResponse.self, from: data)
            let resultsData = decodedResultsData.data
            
            let paginateData = decodedResultsData.data.paginate
            
            var stores: [StoreModel] = []
            var products: [ProductModel] = []
            var paginate: PaginateResultsModel? = nil

            if paginateData != nil {
                paginate = PaginateResultsModel(from: paginateData!.from, current: paginateData!.current, to: paginateData!.to, perPage: paginateData!.per_page, nextPageUrl: paginateData!.next_page_url, currentPageUrl: paginateData!.current_page_url, prevPageUrl: paginateData!.prev_page_url, moreAvailable: paginateData!.more_available)
            }

            for store in resultsData.stores {

                var openingHours: [OpeningHoursModel] = []
                
                if store.opening_hours != nil && store.opening_hours!.count > 0 {
                    let storeHours = store.opening_hours![0]
                    openingHours.append(OpeningHoursModel(storeID: store.id, opensAt: storeHours.opens_at, closesAt: storeHours.closes_at, closedToday: storeHours.closed_today ?? false, dayOfWeek: storeHours.day_of_week))
                }

                stores.append( StoreModel(id: store.id, name: store.name, logo: store.small_logo, openingHours: openingHours, location: LocationModel(storeID: store.id, city: store.location.city, addressLine1: store.location.address_line1, addressLine2: store.location.address_line2, addressLine3: store.location.address_line3, postcode: store.location.postcode,latitude: store.location.latitude, longitude: store.location.longitude), facilities: [], storeTypeID: store.store_type_id))
                
            }
            
            for product in resultsData.products {
                
                var promotion: PromotionModel? = nil
                
                if product.promotion != nil {
                    promotion = PromotionModel(id: product.promotion!.id, name: product.promotion!.name, quantity: product.promotion!.quantity!, price: product.promotion!.price, forQuantity: product.promotion!.for_quantity)
                }
                
                products.append(
                    ProductModel(id: product.id, name: product.name, smallImage: product.small_image, largeImage: product.large_image, description: product.description, quantity: 0, price: product.price, avgRating: product.avg_rating, totalReviewsCount: product.total_reviews_count, promotion: promotion, storage: product.storage, weight: product.weight, parentCategoryId: product.parent_category_id, parentCategoryName: product.parent_category_name, childCategoryName: product.child_category_name, dietaryInfo: product.dietary_info, allergenInfo: product.allergen_info, brand: product.brand, reviews: [], favourite: nil, monitoring: nil, ingredients: [], recommended: [])
                )
                
            }
            
            DispatchQueue.main.async {
                self.resultsDelegate?.contentLoaded(stores: stores, products: products, paginate: paginate)
            }
        
        } catch {
            processError("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.resultsDelegate?.logOutUser()
        self.suggestionsDelegate?.logOutUser()
    }
    
    func processError(_ message:String){
        print(message)
        if (self.suggestionsDelegate != nil){
            self.suggestionsDelegate!.errorHandler(message)
        } else if (self.resultsDelegate != nil){
            self.resultsDelegate!.errorHandler(message)
        }
        
    }
}
