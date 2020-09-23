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
    var height: Float
    
    init(title: String,height: Float) {
        self.title = title
        self.height = height
    }
}

class StoresMapTableViewCell: UITableViewCell,CustomElementCell, CLLocationManagerDelegate {

    var model: StoresMapElement!
    
//    @IBOutlet private var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapViewContainer: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? StoresMapElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        // Initiallising Map. Required. Or MapView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        checkLocationServices()

        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(viewRegion, animated: false)
        }

        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    func checkLocationAuthorization() {
        
        if mapView != nil {
          switch CLLocationManager.authorizationStatus() {
              case .authorizedWhenInUse:
                mapView!.showsUserLocation = true
               case .denied: // Show alert telling users how to turn on permissions
               break
              case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                mapView!.showsUserLocation = true
              case .restricted:
                // Show an alert letting them know what’s up
               break
              case .authorizedAlways:
                // Authorised
               break
          @unknown default:
            fatalError()
          }
            
        }

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
