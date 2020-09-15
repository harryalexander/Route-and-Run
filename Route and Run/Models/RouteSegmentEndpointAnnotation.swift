//
//  RouteSegmentEndpointAnnotation.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class RouteSegmentEndpointAnnotation: NSObject, MKAnnotation {
    var index: Int
    var coordinate: CLLocationCoordinate2D
    
    init(index: Int, coordinate: CLLocationCoordinate2D) {
        self.index = index
        self.coordinate = coordinate
        super.init()
    }
}
