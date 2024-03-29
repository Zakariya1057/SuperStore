//
//  FavouritesPresenterTests.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 24/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import SuperStore
import XCTest

class FavouritesPresenterTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: FavouritesPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupFavouritesPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupFavouritesPresenter()
    {
        sut = FavouritesPresenter()
    }
    
    // MARK: Test doubles
    
    class FavouritesDisplayLogicSpy: FavouritesDisplayLogic
    {
        var presentedProducts: [ProductModel] = []
        
        var displayedFavouritesCalled: Bool = false
        var displayDeletedFavouriteCalled: Bool = false
        
        func displayFavourites(viewModel: Favourites.GetFavourites.ViewModel) {
            presentedProducts = viewModel.products
            displayedFavouritesCalled = true
        }
        
        func displayDeleteFavourite(viewModel: Favourites.DeleteFavourite.ViewModel) {
            displayDeletedFavouriteCalled = false
        }
    }
    
    // MARK: Tests
    
    func testDisplayFavouritesCalled()
    {
        // Given
        let spy = FavouritesDisplayLogicSpy()
        sut.viewController = spy
        
        let products = Seeds.ProductSeed.Products
        let response = Favourites.GetFavourites.Response(products: products)
        
        // When
        sut.presentFavourites(response: response)
        
        // Then
        XCTAssertTrue(spy.displayedFavouritesCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
    
    func testDisplayFavouritesProductsCorrectly()
    {
        // Given
        let favouriteSpy = FavouritesDisplayLogicSpy()
        sut.viewController = favouriteSpy
        
        let products = Seeds.ProductSeed.Products
        let response = Favourites.GetFavourites.Response(products: products)
        
        // When
        sut.presentFavourites(response: response)
        
        // Then
        XCTAssertTrue(favouriteSpy.presentedProducts == products, "presentSomething(response:) should ask the view controller to display the result")
    }
}
