//
//  RouteSection.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

struct RouteSegment {
    let name: String
    let distance: CLLocationDistance
    let source: CLLocationCoordinate2D
    let destination: CLLocationCoordinate2D
    let polyline: MKPolyline
    let directions: [Direction]
    
    init(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: MKRoute) {
        self.name = route.name
        self.distance = route.distance
        self.source = source
        self.destination = destination
        self.polyline = route.polyline
        self.directions = route.steps.map { Direction(instructions: $0.instructions, warnings: $0.notice) }
    }
}

struct Direction {
    let instructions: String
    let warnings: String?
}
