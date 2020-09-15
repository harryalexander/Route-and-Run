//
//  RouteSourceAnnotation.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class RouteSourceAnnotation: NSObject, MKAnnotation {
    var index: Int
    var coordinate: CLLocationCoordinate2D {
        return self.placemark.coordinate
    }
    var placemark: MKPlacemark
    var message: String {
        return "Starting route at \(placemark.title ?? placemark.coordinate.description)"
    }
    
    init(index: Int, placemark: MKPlacemark) {
        self.placemark = placemark
        self.index = index
        super.init()
    }
}
