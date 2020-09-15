//
//  CLLocationCoordinate2D+Extensions.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    var description: String {
        return "(LON: \(longitude), LAT: \(latitude))"
    }
    func convertToMapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: self)
        let mapItem = MKMapItem(placemark: placemark)
        
        return mapItem
    }
    
    func toViewCoordinateIn(mapView: MKMapView) -> CGPoint {
        return mapView.convert(self, toPointTo: mapView)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
