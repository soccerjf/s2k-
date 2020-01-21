//
//  FieldDetails.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-21.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class FieldDetails: NSObject, MKAnnotation {
    let title: String?
    let gameDetails: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, gameDetails: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.gameDetails = gameDetails
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return gameDetails
    }
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
