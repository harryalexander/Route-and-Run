//
//  DirectionsRequestController.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/8/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class DirectionsRequestController: NSObject, DirectionsRequester {
    func fetchRouteDataBetween(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, onResponse: @escaping (MKRoute?) -> Void) {
        let request = MKDirections.Request()
        request.transportType = .walking
        
        let startPlacemark = MKPlacemark(coordinate: start)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        request.source = startMapItem
        request.destination = destinationMapItem
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard error == nil else {
                onResponse(nil)
                return
            }
            onResponse(response?.routes.first)
        }
    }
}
