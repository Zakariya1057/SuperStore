//
//  StoresResultsTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoreResultCell: UITableViewCell {
    
//    @IBOutlet var storeImageView: UIImageView!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var openStatusLabel: UILabel!
//
//    var day_of_week: Int {
//        var day_of_week = Calendar.current.component(.weekday, from: Date()) - 2
//
//        if day_of_week == -1 {
//            day_of_week = 6
//        }
//
//        return day_of_week
//    }
//
//    var loadingViews: [UIView] {
//        return [addressLabel,nameLabel,openStatusLabel,storeImageView]
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        configureUI()
//    }
//
//    func configureUI(){
//        stopLoading()
//
//        if store != nil {
//            nameLabel.text = store!.name
//
//            let location = store!.location
//            let address = [location.addressLine1, location.addressLine2, location.addressLine3, location.city ]
//            addressLabel.text = address.compactMap { $0 }.joined(separator: ", ")
//
//            if store!.openingHours.count == 0 {
//                openStatusLabel.text = ""
//            } else if store!.openingHours.count == 1 {
//                let hour = store!.openingHours[0]
//
//                if hour.closedToday {
//                    openStatusLabel.text = "Closed"
//                } else {
//                    openStatusLabel.text = "\(hour.opensAt!.lowercased()) - \(hour.closesAt!.lowercased())"
//                }
//
//            } else {
//                // Multiple hours given, all days of week.
//                let hour = store!.openingHours.first { (hour) -> Bool in
//                    return hour.dayOfWeek == day_of_week
//                }
//
//                if(hour != nil){
//                    if hour!.closedToday {
//                        openStatusLabel.text = "Closed Today"
//                    } else {
//                        openStatusLabel.text = "\(hour!.opensAt!.lowercased()) - \(hour!.closesAt!.lowercased())"
//                    }
//                } else {
//                    print("No Hour For Day Given")
//                }
//
//            }
//
//        }
//    }
    
    var store: StoreModel!
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var openingHoursLabel: UILabel!
    
    func configureUI(){
        nameLabel.text = store.name
        logoImageView.downloaded(from: store.logo)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func startLoading(){
//        for item in loadingViews {
//            item.isSkeletonable = true
//            item.showAnimatedGradientSkeleton()
//        }
//    }
//
//    func stopLoading(){
//        for item in loadingViews {
//            item.hideSkeleton()
//        }
//    }
    
}
