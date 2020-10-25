//
//  DataHandler.swift
//  ZPlayer
//
//  Created by Zakariya Mohummed on 25/05/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import Foundation

protocol SearchSuggestionsDelegate {
    func contentLoaded(suggestions: [SearchModel])
    func errorHandler(_ message:String)
    func logOutUser()
}

protocol SearchResultsDelegate {
    func contentLoaded(stores: [StoreModel], products: [ProductModel], filters: [RefineOptionModel], paginate: PaginateResultsModel?)
    func errorHandler(_ message:String)
    func logOutUser()
}

struct SearchHandler {
    
    var suggestionsDelegate: SearchSuggestionsDelegate?
    var resultsDelegate: SearchResultsDelegate?
    
    let requestHandler = RequestHandler()
    
    func requestSuggestions(query: String){
        let hostURL = K.Host
        let suggestionsPath = K.Request.Search.Suggestions
        let urlString = "\(hostURL)/\(suggestionsPath)/\(query)"
        requestHandler.getRequest(url: urlString, complete: processSuggestionsResults,error:processError,logOutUser: logOutUser)
    }
    
    func requestResults(searchData: [String: String], page: Int = 1){
        let hostURL = K.Host
        let resultsPath = K.Request.Search.Results
        let urlString = "\(hostURL)/\(resultsPath)?page=\(page)"
        requestHandler.postRequest(url: urlString, data: searchData, complete: processResults, error: processError,logOutUser: logOutUser)
    }
    
    func processSuggestionsResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
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
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func processResults(_ data:Data){
        
        do {
            
            print("Processing Results")
            
            let decoder = JSONDecoder()
            let decodedResultsData = try decoder.decode(SearchResultsDataResponse.self, from: data)
            let resultsData = decodedResultsData.data
            
            let paginateData = decodedResultsData.data.paginate
            
            var stores: [StoreModel] = []
            var products: [ProductModel] = []
            var paginate: PaginateResultsModel? = nil
            
            var filterCategories: RefineOptionModel = RefineOptionModel(header: "Categories", values: [], type: .category)
            var filterBrands: RefineOptionModel = RefineOptionModel(header: "Brands", values: [], type: .brand)
            
            let filterResults = resultsData.filter ?? FilterResultsData(brands: [:], categories: [:])
            
            for brand in filterResults.brands ?? [:] {
                filterBrands.values.append(RefineModel(name: brand.key, selected: false, quantity: brand.value))
            }
            
            for categories in filterResults.categories ?? [:] {
                filterCategories.values.append(RefineModel(name: categories.key, selected: false, quantity: categories.value))
            }
            
            if paginateData != nil {
                print("Paginate Data Found")
                paginate = PaginateResultsModel(from: paginateData!.from, current: paginateData!.current, to: paginateData!.to, per_page: paginateData!.per_page, next_page_url: paginateData!.next_page_url, current_page_url: paginateData!.current_page_url, prev_page_url: paginateData!.prev_page_url, more_available: paginateData!.more_available)
            }
            
            let filters: [RefineOptionModel] = [filterCategories, filterBrands]

            for store in resultsData.stores {
                let hour = OpeningHoursModel(store_id: store.id, opens_at: store.opens_at!, closes_at: store.closes_at!, closed_today: false, day_of_week: 1)
                
                stores.append( StoreModel(id: store.id, name: store.name, logo: store.small_logo, opening_hours: [hour], location: LocationModel(store_id: store.id, city: store.location.city, address_line1: store.location.address_line1, address_line2: store.location.address_line2, address_line3: store.location.address_line3, postcode: store.location.postcode,latitude: store.location.latitude, longitude: store.location.longitude), facilities: [], store_type_id: store.store_type_id))
                
            }
            
            for product_item in resultsData.products {
                
                var promotion: PromotionModel? = nil
                
                if product_item.promotion != nil {
                    promotion = PromotionModel(id: product_item.promotion!.id, name: product_item.promotion!.name, quantity: product_item.promotion!.quantity!, price: product_item.promotion!.price, forQuantity: product_item.promotion!.for_quantity)
                }
                
                products.append( ProductModel(id: product_item.id, name: product_item.name, image: product_item.small_image, quantity: 0, product_id: product_item.id, price: product_item.price, weight: product_item.weight, promotion: promotion, description: product_item.description, favourite: product_item.favourite, monitoring: nil, avgRating: product_item.avg_rating, totalReviewsCount: product_item.total_reviews_count, parentCategoryId: product_item.parent_category_id, parentCategoryName: product_item.parent_category_name) )
            }
            
            DispatchQueue.main.async {
                self.resultsDelegate?.contentLoaded(stores: stores, products: products, filters: filters, paginate: paginate)
            }
        
        } catch {
            print("Decoding Data Error: \(error)")
        }
        
        
    }
    
    func logOutUser(){
        self.resultsDelegate?.logOutUser()
        self.suggestionsDelegate?.logOutUser()
    }
    
    func processError(_ message:String){
        if (self.suggestionsDelegate != nil){
            self.suggestionsDelegate!.errorHandler(message)
        } else if (self.resultsDelegate != nil){
            self.resultsDelegate!.errorHandler(message)
        }
        
    }
}
