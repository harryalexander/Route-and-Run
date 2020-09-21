//
//  MapsServiceController.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class AppleMapsService: NSObject {}

extension AppleMapsService: MapAPI {
    func requestRouteFromSource(_ source: CLLocationCoordinate2D, toDestination destination: CLLocationCoordinate2D, onCompletion: @escaping (RouteRequestResult) -> Void) {
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = source.convertToMapItem()
        request.destination = destination.convertToMapItem()
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard error == nil, let route = response?.routes.first else {
                let result = RouteRequestResult.failure(error!)
                onCompletion(result)
                return
            }
            let result = RouteRequestResult.success(route)
            onCompletion(result)
        }
    }
    
    func sendSearchRequestFor(query: String,
                              onCompletion: @escaping (LocationSearchResult) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard error == nil, let results = response?.mapItems else {
                onCompletion(LocationSearchResult.failure(error!))
                return
            }
            onCompletion(LocationSearchResult.success(results))
        }
    }
}
