//
//  ErrorAnnotation.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class ErrorAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var errorMessage: String
    init(errorMessage: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.errorMessage = errorMessage
        super.init()
    }
}
