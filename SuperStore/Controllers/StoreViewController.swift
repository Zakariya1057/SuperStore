//
//  StoreViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import SkeletonView

class StoreViewController: UIViewController, StoreDelegate {
    
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
        var views:[UIView] = [storeLogoView, storeAddressLabel,storeNameLabel,groceryButton]
        views.append(contentsOf: dayLabels.compactMap { $0 } )
        views.append(contentsOf: hoursLabels.compactMap { $0 } )
        views.append(contentsOf: facilityLabel.compactMap { $0 } )
        return views
    }
    
    var removed:Bool = false
    var storeHandler:StoreHandler = StoreHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeHandler.delegate = self
        print("Requesting Store Details")
        
        startLoading()
        storeHandler.request(store_id: 1)
        
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
        
        let opening_hours = store.opening_hours
        let facilities = store.facilities
        let location = store.location
        

        configureDetails(store: store)
        configureOpeningHours(opening_hours: opening_hours)
        configureLocation(location: location)
        configureFacilites(facilities: facilities)
    }
    
    func configureDetails(store: StoreModel){
        let name = store.name
        let logo = store.logo
        
        storeLogoView.downloaded(from: logo)
        storeNameLabel.text = name
    }
    
    func configureOpeningHours(opening_hours: [OpeningHoursModel]){
//        let day_of_week = 7 - Calendar.current.component(.weekday, from: Date())
        
        let day_of_week = Calendar.current.component(.weekday, from: Date()) - 2
        
//        print("Day Of Week: \(day_of_week)")
        
        for (index, hourLabel) in hoursLabels.enumerated() {
            let day = opening_hours[index]
            let day_name = dayLabels[index]
            
            if day.day_of_week == day_of_week {
                hourLabel.textColor = .systemBlue
                day_name.textColor = .systemBlue
            }
            
            hourLabel.text = "\(day.opens_at) - \(day.closes_at)".lowercased()
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
            
            if !facilities.contains(check["contains"] as! String) {
                let view = check["view"] as! UIView
                 view.removeFromSuperview()
            }
            
        }

    }
    
    func configureLocation(location: LocationModel){
        let address_items = [location.address_line1, location.address_line2, location.address_line3, location.city ]
        storeAddressLabel.text = address_items.compactMap { $0 }.joined(separator: ", ")
    }
    
//    func toggleAnimation() {
//        if !skeletonAnimating {
//            print("Start Animating")
//            view.startSkeletonAnimation()
//        } else {
//            print("Stop Animating")
//            view.stopSkeletonAnimation()
//        }
//
//        skeletonAnimating = !skeletonAnimating
//    }

}
