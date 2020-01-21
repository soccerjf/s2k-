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
}
