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
    @IBAction func mapHelp(_ sender: Any) {
        performSegue(withIdentifier: "MapHelpSegue", sender: nil)
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
        mapView.delegate = self
        print(latitude)
        print(longitude)
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let fieldDetails = FieldDetails(title: fieldName, gameDetails: gameDetails, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.addAnnotation(fieldDetails)
        centerMapOnLocation(location: initialLocation)
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "MapHelpSegue" {
            if let dest = segue.destination as? HelpVC {
                dest.sourceID = "Map"
            }
        }
    }
}
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? FieldDetails else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! FieldDetails
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
