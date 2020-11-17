//
//  StoreViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import SkeletonView
import RealmSwift

class StoreViewController: UIViewController, StoreDelegate {
    
    var selectedListID: Int?
    
    let realm = try! Realm()
    
    var store: StoreHistory? {
        get {
            return realm.objects(StoreHistory.self).filter("id = \(storeID)").first
        }
    }
    
    var userHandler = UserHandler()
    
    @IBOutlet weak var storeLogoView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeNameView: UIView!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var groceryButton: UIButton!
    
    // Opening Hours Labels START
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuedayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    
    @IBOutlet weak var mondayTextLabel: UILabel!
    @IBOutlet weak var tuesdayTextLabel: UILabel!
    @IBOutlet weak var wednesdayTextLabel: UILabel!
    @IBOutlet weak var thurdayTextLabel: UILabel!
    @IBOutlet weak var fridayTextLabel: UILabel!
    @IBOutlet weak var saturdayTextLabel: UILabel!
    @IBOutlet weak var sundatTextLabel: UILabel!
    // Opening Hours Labels END
    
    
    // Facilities Labels START
    @IBOutlet weak var carView: UIStackView!
    @IBOutlet weak var customerWCView: UIStackView!
    @IBOutlet weak var heliumBalloonsView: UIStackView!
    @IBOutlet weak var disabledView: UIStackView!
    @IBOutlet weak var chargingView: UIStackView!
    @IBOutlet weak var paypointView: UIStackView!
    @IBOutlet weak var atmView: UIStackView!
    @IBOutlet weak var babyChangingView: UIStackView!
    // Facilities Labels END

    
    var hoursLabels:[UILabel] {
        return [mondayLabel,tuedayLabel,wednesdayLabel,thursdayLabel,fridayLabel,saturdayLabel,sundayLabel]
    }
    
    var dayLabels:[UILabel] {
        return [mondayTextLabel,tuesdayTextLabel,wednesdayTextLabel, thurdayTextLabel, fridayTextLabel, saturdayTextLabel, sundatTextLabel]
    }
    
    var facilityLabel: [UIView] {
        return [carView,customerWCView,heliumBalloonsView,disabledView,chargingView,paypointView,atmView,babyChangingView]
    }
    
    var loadingViews: [UIView] {
        var views:[UIView] = [storeAddressLabel,storeNameLabel,groceryButton]
        views.append(contentsOf: dayLabels.compactMap { $0 } )
        views.append(contentsOf: hoursLabels.compactMap { $0 } )
        views.append(contentsOf: facilityLabel.compactMap { $0 } )
        return views
    }
    
    var removed:Bool = false
    var storeHandler:StoreHandler = StoreHandler()
    
    var storeID: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeHandler.delegate = self
        
        startLoading()
        storeHandler.request(store_id: storeID)
        
        if store != nil {
            stopLoading()
            configureUI()
        }
        
    }
    
    func startLoading(){
        for item in loadingViews {
            item.isSkeletonable = true
            item.showAnimatedGradientSkeleton()
        }
    }
    
    func stopLoading(){
        for item in loadingViews {
            item.hideSkeleton()
        }
    }
    
    func contentLoaded(store: StoreModel) {
        stopLoading()
        addToHistory(store)
        configureUI()
    }
    
    func logOutUser(){
        userHandler.userSession.viewController = self
        userHandler.requestLogout()
    }
    
    func errorHandler(_ message: String) {
        showError(message)
    }
    
    func configureUI(){
        
        let storeItem = store!.getStoreModel()
        
        let openingHours = storeItem.openingHours
        let facilities = storeItem.facilities
        let location = storeItem.location
        

        configureDetails(store: storeItem)
        configureOpeningHours(openingHours: openingHours)
        configureLocation(location: location)
        configureFacilites(facilities: facilities)
    }
    
    func configureDetails(store: StoreModel){
        let name = store.name
        let logo = store.logo
        
        storeLogoView.downloaded(from: logo)
        storeNameLabel.text = name
    }
    
    func configureOpeningHours(openingHours: [OpeningHoursModel]){
        
        if openingHours.count == 7 {
            
            var day_of_week = Calendar.current.component(.weekday, from: Date()) - 2
            
            if day_of_week == -1 {
                day_of_week = 6
            }
            
            for (index, hourLabel) in hoursLabels.enumerated() {
                
                if openingHours.indices.contains(index) {
                    let day = openingHours[index]
                    let day_name = dayLabels[index]
                    
                    if day.dayOfWeek == day_of_week {
                        hourLabel.textColor = .systemBlue
                        day_name.textColor = .systemBlue
                    }
                    
                    if day.closedToday {
                        hourLabel.text = "Closed"
                    } else {
                        hourLabel.text = "\(day.opensAt!) - \(day.closesAt!)".lowercased()
                    }
                    
                }

            }

        } else {
            hoursLabels.forEach({ $0.text = "" })
        }

    }
    
    func configureFacilites(facilities: [String]){
        
        let check_facilities:[ [String: Any] ] = [
            ["view": carView!, "contains": "car park"],
            ["view": customerWCView!, "contains": "customer wc"],
            ["view": atmView!, "contains": "cash machine"],
            ["view": babyChangingView!, "contains": "baby changing"],
            ["view": heliumBalloonsView!, "contains": "balloons"],
            ["view": chargingView!, "contains": "charging"],
            ["view": paypointView!, "contains": "paypoint"],
            ["view": disabledView!, "contains": "disabled facilities"],
        ]
        
        for check in check_facilities {
            
            let view = check["view"] as! UIView
            
            if !facilities.contains(check["contains"] as! String) {
                view.isHidden =  true
            } else {
                view.isHidden =  false
            }
            
        }

    }
    
    func configureLocation(location: LocationModel){
        let address_items = [location.addressLine1, location.addressLine2, location.addressLine3, location.city ]
        storeAddressLabel.text = address_items.compactMap { $0 }.joined(separator: ", ")
    }
    
    func showError(_ error: String){
        let alert = UIAlertController(title: "Store Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GrandParentCategoriesViewController
        destinationVC.selectedListID = self.selectedListID
        destinationVC.storeTypeID = store!.getStoreModel().storeTypeID
    }
    
}

extension StoreViewController {
    func addToHistory(_ storeItem: StoreModel){
        
        try! realm.write() {
            if store == nil {
                realm.add(storeItem.getRealmObject())
            } else {
                
                store!.facilities.removeAll()
                store!.openingHours.removeAll()
                
                let storeHistory = storeItem.getRealmObject()
                
                storeHistory.facilities.forEach({ store!.facilities.append($0) })
                storeHistory.openingHours.forEach({ store!.openingHours.append($0) })
                
                store!.logo = storeHistory.logo
                store!.name = storeHistory.name
                
            }
            
        }
        
    }
    
}
