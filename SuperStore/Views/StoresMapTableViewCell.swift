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
    var position: CGFloat?
    var stores: [StoreModel]?
    var errorDelegate: UserLocationDeniedDelegate?
    var loading: Bool = false
    var delegate: StoreSelectedDelegate?
    
    init(title: String, stores:[StoreModel], delegate: StoreSelectedDelegate, errorDelegate: UserLocationDeniedDelegate) {
        self.title = title
        self.stores = stores
        self.delegate = delegate
        self.errorDelegate = errorDelegate
    }
}

protocol UserLocationDeniedDelegate {
    func showError(_ error: String)
}

protocol StoreSelectedDelegate {
    func storePressed(store_id: Int)
    func storeSelected(store_id: Int)
}

class StoresMapTableViewCell: UITableViewCell,CustomElementCell, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var model: StoresMapElement!
    var stores: [StoreModel] = []
    
    var delegate: StoreSelectedDelegate?
    
    var errorDelegate: UserLocationDeniedDelegate?
    
    var selected_store_id: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapViewContainer: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var store_details: [String: Int] = [:]
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? StoresMapElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        
        self.model = model
        self.stores = model.stores ?? []
        self.delegate = model.delegate
        self.errorDelegate = model.errorDelegate
        
        configureUI()
    }
    
    func configureUI() {
        // Initiallising Map. Required. Or MapView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationServices()
        
        zoomUserLocation()
        
        mapView.delegate = self
        
        showStoreLocations()
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func zoomUserLocation(){
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    func showStoreLocations(){
        
        for store in stores {
            let annotation = MKPointAnnotation()
            annotation.title = store.name
            
            let location = store.location
            let addressList = [location.address_line1, location.address_line2, location.address_line3, location.city ]
            let address = addressList.compactMap { $0 }.joined(separator: ", ")
            
            annotation.subtitle = address
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(store.location.latitude),
                longitude: CLLocationDegrees(store.location.longitude)
            )
            
            self.mapView.addAnnotation(annotation)
            
            store_details[store.name] = store.id
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else {
            // this is our unique identifier for view reuse
            let identifier = "Capital"
            
            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                // we didn't find one; make a new one
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                
                // Creating Button
                let button = UIButton(type: .detailDisclosure)
                button.addTarget(self, action: #selector(showStore), for: .touchUpInside)
                
                // attach an information button to the view
                annotationView?.rightCalloutAccessoryView = button
                
            } else {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
            // whether it's a new view or a recycled one, send it back
            return annotationView
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title!
        selected_store_id = store_details[title!]
        
        if selected_store_id != nil {
            delegate?.storePressed(store_id: selected_store_id!)
        }
        
    }
    
    @objc func showStore(){
        self.delegate?.storeSelected(store_id: selected_store_id!)
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
                zoomUserLocation()
            case .denied: // Show alert telling users how to turn on permissions
                print("User Location Permission Denied")
                // errorDelegate?.showError("User location permission denied.\nPlease change from Apple settings.")
                break
            case .authorizedAlways:
                locationManager.requestWhenInUseAuthorization()
                mapView!.showsUserLocation = true
                zoomUserLocation()
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                mapView!.showsUserLocation = true
                zoomUserLocation()
            case .restricted:
                errorDelegate?.showError("User location permission denied.\nPlease change from Apple settings.")
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

