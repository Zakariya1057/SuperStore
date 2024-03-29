//
//  StoreViewControllerTests.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 23/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import SuperStore
import XCTest

class StoreViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: StoreViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupStoreViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupStoreViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class StoreBusinessLogicSpy: StoreBusinessLogic
    {
        
        var selectedListID: Int?
        
        var getStoreCalled = false
        
        func getStore(request: Store.GetStore.Request) {
            getStoreCalled = true
        }
    }
    
    // MARK: Tests

    func testShouldGetStoreWhenViewIsLoaded()
    {
        // Given
        let spy = StoreBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.getStoreCalled, "viewDidLoad() should ask the interactor to get store")
    }
    
    func testDisplayStoreShouldUpdateDetailFields()
    {
        // Given
        let spy = StoreBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        // When
        let displayStore = Seeds.StoreSeed.DisplayedStores.first!
        
        let viewModel = Store.GetStore.ViewModel(displayedStore: displayStore, error: nil)
        sut.displayStore(viewModel: viewModel)
        
        // Then
        
        let name: String = displayStore.name
        let address: String = displayStore.address
        let logo: UIImage? = displayStore.logoImage
        
        XCTAssertEqual(sut.logoImageView.image, logo!, "Displaying store should update store logo image")
        XCTAssertEqual(sut.nameLabel.text, name, "Displaying store should update store name label")
        XCTAssertEqual(sut.addressLabel.text, address, "Displaying store should update store address label")
    }
    
    func testDisplayStoreShouldUpdateFacilities(){
        // Given
        let spy = StoreBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        // When
        let displayStore = Seeds.StoreSeed.DisplayedStores.first!
        
        let viewModel = Store.GetStore.ViewModel(displayedStore: displayStore, error: nil)
        sut.displayStore(viewModel: viewModel)
        
        // Then
        let facilities: [Store.DisplayFacility] = displayStore.facilities
        let facilitiesTableView: UITableView = sut.facilitiesTableView
        
        for (index, facility) in facilities.enumerated() {
            if let cell = facilitiesTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FacilityTableViewCell {
                XCTAssertEqual(cell.nameLabel.text, facility.name, "Displaying store should update store address label")
                XCTAssertEqual(cell.iconImageView.image, facility.icon, "Displaying store should update store address label")
            } else {
                XCTFail("Facility TableViewCell Row Not Found At Row: \(index)")
            }
        }
    }
    
    func testDisplayStoreShouldUpdateOpeningHours(){
        // Given
        let spy = StoreBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        // When
        let displayStore = Seeds.StoreSeed.DisplayedStores.first!
        
        let viewModel = Store.GetStore.ViewModel(displayedStore: displayStore, error: nil)
        sut.displayStore(viewModel: viewModel)
        
        // Then
        let openingHours: [Store.DisplayOpeningHour] = displayStore.openingHours
        let openingHoursTableView: UITableView = sut.hoursTableView
        
        for (index, hour) in openingHours.enumerated() {
            if let cell = openingHoursTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? OpeningHourTableViewCell {
                XCTAssertEqual(cell.dayLabel.text, hour.day, "Displaying store should update store address label")
                XCTAssertEqual(cell.hourLabel.text, hour.hours, "Displaying store should update store address label")
            } else {
                XCTFail("OpeningHour TableViewCell Row Not Found At Row: \(index)")
            }
        }
    }
        
        
    func testDisplayRightBarButtonHidden()
    {
        // Given
        let spy = StoreBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertNil(sut.navigationItem.rightBarButtonItem, "Right Bar Button Should Not Be Showing")
    }
    
    func testDisplayRightBarButtonShowing()
    {
        // Given
        let spy = StoreBusinessLogicSpy()
        spy.selectedListID = 1
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem, "Right Bar Button Should Be Not Removed")
    }
}
