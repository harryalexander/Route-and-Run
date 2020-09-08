//
//  CreateRouteViewControllerDelegate.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/8/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol CreateRouteView {
    var map: MKMapView! { get }
    func centerMapAtStart(location: CLLocationCoordinate2D)
    
}
