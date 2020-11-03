//
//  StoresResultsTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoresResultsTableViewCell: UITableViewCell {

    var store: StoreModel?
    
    @IBOutlet var storeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    
    var day_of_week: Int {
        var day_of_week = Calendar.current.component(.weekday, from: Date()) - 2
        
        if day_of_week == -1 {
            day_of_week = 6
        }
        
        return day_of_week
    }
    
    var loadingViews: [UIView] {
        return [addressLabel,nameLabel,openStatusLabel,storeImageView]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI(){
        stopLoading()
        
        if store != nil {
            nameLabel.text = store!.name
            
            let location = store!.location
            let address = [location.address_line1, location.address_line2, location.address_line3, location.city ]
            addressLabel.text = address.compactMap { $0 }.joined(separator: ", ")
            
            if store!.opening_hours.count > 0 &&  store!.opening_hours[0].day_of_week == day_of_week {
                let hours = store!.opening_hours[0]
                openStatusLabel.text = "\(hours.opens_at.lowercased()) - \(hours.closes_at.lowercased())"
            } else {
                openStatusLabel.text = ""
            }

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
}
