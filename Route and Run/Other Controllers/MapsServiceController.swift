//
//  MapsServiceController.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class MapsServiceController: NSObject, MapRequester {
    func getDirectionsFrom(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, onResponse: @escaping (MKRoute?, Error?) -> Void) {
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = source.convertToMapItem()
        request.destination = destination.convertToMapItem()
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard error == nil else {
                onResponse(nil, error)
                return
            }
            onResponse(response?.routes.first, nil)
        }
    }
    
    func search(query: String, onResponse: @escaping (MKLocalSearch.Response?, Error?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            onResponse(response, error)
        }
    }
}
