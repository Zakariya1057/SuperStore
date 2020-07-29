//
//  StoresMapTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import MapKit

class StoresMapElement: CustomElementModel {
    var title: String
    var type: CustomElementType { return .storesMap }
    
    init(title: String) {
        self.title = title
    }
}

class StoresMapTableViewCell: UITableViewCell,CustomElementCell {

    var model: StoresMapElement!
    
    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? StoresMapElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
//        titleLabel.text = self.model.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        let location = CLLocation(latitude: 52.479948, longitude: -1.894813)
//        mapView.centerToLocation(location)
        
//        let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
//        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
