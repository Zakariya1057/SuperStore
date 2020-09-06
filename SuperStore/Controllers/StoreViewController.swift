//
//  StoreViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 22/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, StoreDelegate {
    
    @IBOutlet weak var storeLogoView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeNameView: UIView!
    @IBOutlet weak var storeAddressLabel: UILabel!
    
    // Opening Hours Labels START
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuedayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    @IBOutlet weak var babyChangingView: UIStackView!
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
    // Facilities Labels END

    
    @IBOutlet weak var atmView: UIStackView!
    
    var hours_labels:[UILabel] {
        return [mondayLabel,tuedayLabel,wednesdayLabel,thursdayLabel,fridayLabel,saturdayLabel,sundayLabel]
    }
    
    var day_labels:[UILabel] {
        return [mondayTextLabel,tuesdayTextLabel,wednesdayTextLabel, thurdayTextLabel, fridayTextLabel, saturdayTextLabel, sundatTextLabel]
    }
    
    var removed:Bool = false
    var storeHandler:StoreHandler = StoreHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storeHandler.delegate = self
        print("Requesting Store Details")
        
        storeHandler.request(store_id: 1)
        // Do any additional setup after loading the view.
        
    }
    
    func contentLoaded(store: StoreModel) {

        
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
        
//        if name.count > 24 {
//            storeNameView.addConstraint(NSLayoutConstraint(item: storeNameView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
//
//        } else {
//                        storeNameView.addConstraint(NSLayoutConstraint(item: storeNameView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25))
//        }
        
        storeNameLabel.text = name
    }
    
    func configureOpeningHours(opening_hours: [OpeningHoursModel]){
        let day_of_week = 7 - Calendar.current.component(.weekday, from: Date())
        
        print("Day Of Week: \(day_of_week)")
        
        for (index, hour_label) in hours_labels.enumerated() {
            let day = opening_hours[index]
            let day_name = day_labels[index]
            
            if day.day_of_week == day_of_week {
                hour_label.textColor = .systemBlue
                day_name.textColor = .systemBlue
            }
            
            hour_label.text = "\(day.opens_at) - \(day.closes_at)".lowercased()
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

}
