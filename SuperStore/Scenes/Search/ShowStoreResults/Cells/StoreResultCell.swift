//
//  StoresResultsTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 29/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit

class StoreResultCell: UITableViewCell {
    
    var store: ShowStoreResults.DisplayedStore?
    
    @IBOutlet var loadingViews: [UIView]!
    
    var loading: Bool = true {
        didSet {
            loading ? startLoading() : stopLoading()
        }
    }
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var openingHoursLabel: UILabel!
    
    func configureUI(){
        if let store = store {
            nameLabel.text = store.name
            logoImageView.downloaded(from: store.logo)
            addressLabel.text = store.address
            openingHoursLabel.text = store.openingHour
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension StoreResultCell {
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
