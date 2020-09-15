//
//  MapRequester.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol MapRequester {
    func getDirectionsFrom(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, onResponse: @escaping (MKRoute?, Error?) -> Void)
    func search(query: String, onResponse: @escaping (MKLocalSearch.Response?, Error?) -> Void)
}
