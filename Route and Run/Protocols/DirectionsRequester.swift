//
//  DirectionsRequester.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/8/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol DirectionsRequester {
    func fetchRouteDataBetween(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, onResponse: @escaping (MKRoute?) -> Void)
}
