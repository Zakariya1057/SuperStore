//
//  StoresMapTableViewCell.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 27/07/2020.
//  Copyright © 2020 Zakariya Mohummed. All rights reserved.
//

import UIKit
import MapKit

class StoreMapGroupElement: HomeElementGroupModel {
    var title: String
    var type: HomeElementType = .storesMap
    var items: [HomeElementItemModel]
    var storePressed: ((Int) -> Void)? = nil
    
    var userLocationFetched: ((CLLocationCoordinate2D?) -> Void)?
    
    var loading: Bool = true
    
    var showViewAllButton: Bool = true
    
    init(title: String, stores: [StoresMapElementModel], storePressed: ((Int) -> Void)?, userLocationFetched: ((CLLocationCoordinate2D?) -> Void)?) {
        self.title = title
        self.items = stores
        
        self.storePressed = storePressed
        self.userLocationFetched = userLocationFetched
        
        configurePressed()
    }
    
    func configurePressed(){
        let stores = items as! [StoresMapElementModel]
        for store in stores {
            store.userLocationFetched = userLocationFetched
            store.storePressed = storePressed
        }
    }
}

class StoresMapElementModel: HomeElementItemModel {
    var stores: [StoreModel] = []
    var storePressed: ((Int) -> Void)? = nil
    var userLocationFetched: ((CLLocationCoordinate2D?) -> Void)?
    var loading: Bool = true
    
    init(stores: [StoreModel]) {
        self.stores = stores
    }
}

class StoresMapCell: UITableViewCell, HomeElementCell, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var model: StoresMapElementModel!
    var stores: [StoreModel] = []
    
    var userLocationFetched: ((CLLocationCoordinate2D?) -> Void)? = nil
    
    var storePressed: ((Int) -> Void)? = nil
    var storeHighlighted: ((Int) -> Void)? = nil
    
    var selectedStoreID: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapViewContainer: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapHeight: NSLayoutConstraint!
    
    var storesDetails: [String: Int] = [:]
    
    func configure(model elementModel: HomeElementItemModel) {
        guard let model = elementModel as? StoresMapElementModel else {
            print("Unable to cast model as StoresMapElementModel: \(elementModel)")
            return
        }
        
        self.model = model
        self.stores = model.stores
        self.userLocationFetched = model.userLocationFetched
        self.storePressed = model.storePressed
        
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
        if let userLocation = locationManager.location?.coordinate {
            
            if let userLocationFetched = userLocationFetched {
                userLocationFetched(userLocation)
            }
            
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 30000, longitudinalMeters: 30000)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    func showStoreLocations(){
        
        removeAllAnotations()
        
        for store in stores {
            
            if let longitude = store.location.longitude, let latitude = store.location.latitude {
                let annotation = MKPointAnnotation()
                annotation.title = store.name
                
                annotation.subtitle = store.getAddress()
                annotation.coordinate = CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(latitude),
                    longitude: CLLocationDegrees(longitude)
                )
                
                self.mapView.addAnnotation(annotation)
                
                storesDetails[store.name] = store.id
            }
            
        }
        
    }
    
    func removeAllAnotations(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
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
        
        if let selectedStoreID = storesDetails[title!] {
            self.selectedStoreID = selectedStoreID
            
            if let storeHighlighted = storeHighlighted {
                storeHighlighted(selectedStoreID)
            }
        }

    }
    
    @objc func showStore(){
        if let selectedStoreID = selectedStoreID, let storePressed = storePressed {
            storePressed(selectedStoreID)
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
                zoomUserLocation()
            case .denied: // Show alert telling users how to turn on permissions
                print("User Location Permission Denied")
                locationNotFound()
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
                print("User location permission denied.\nPlease change from Apple settings.")
                locationNotFound()
                break
            @unknown default:
                fatalError()
            }
            
        }
        
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        zoomUserLocation()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let userLocationFetched = userLocationFetched {
            userLocationFetched(userLocation.coordinate)
        }
    }
    
    func locationNotFound(){
        if let userLocationFetched = userLocationFetched {
            print("Location Not Found")
            userLocationFetched(nil)
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

