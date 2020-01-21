//
//  MapVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-21.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    var latitude = 0.000
    var longitude = 0.000
    var fieldName = ""
    var gameDetails = ""
    let regionRadius: CLLocationDistance = 500
    var currentCoordinates: CLLocationCoordinate2D!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
           mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let fieldDetails = FieldDetails(title: fieldName, gameDetails: gameDetails, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.addAnnotation(fieldDetails)
        centerMapOnLocation(location: initialLocation)
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
