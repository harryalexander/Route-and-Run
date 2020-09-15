//
//  PendingWaypointAnnotation.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class PendingWaypointAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var message: String
    
    init(placemark: MKPlacemark) {
        self.coordinate = placemark.coordinate
        self.message = "Adding \(placemark.title ?? "this location") to your route"
        super.init()
    }
}
