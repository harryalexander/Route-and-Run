//
//  Route.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/6/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class Route: NSObject {
    var name: String
    let timeCreated: Date
    let points: [MKMapPoint]
    
    init(name: String?, timeCreated: Date, points: [MKMapPoint]) {
        self.name = name ?? "Unnamed Route"
        self.timeCreated = timeCreated
        self.points = points
        super.init()
    }
}
