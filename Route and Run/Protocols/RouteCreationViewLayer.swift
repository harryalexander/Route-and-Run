//
//  CreateRouteViewControllerDelegate.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/8/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol RouteCreationViewLayer {
    func setIsUndoButtonEnabled(isEnabled: Bool)
    
    func renderSearchResults(results: [MKPlacemark])
    
    func renderRouteSourceAnnotation(placemark: MKPlacemark)
    func eraseRouteSourceAnnotation()
    
    func renderRouteSegment(segment: RouteSegment, withIndex index: Int)
    func eraseRouteSegmentWith(index: Int)
    func renderRouteSegmentNetworkingError(error: Error, forDestination destination: CLLocationCoordinate2D)
    
    func renderPendingWaypointAnnotation(placemark: MKPlacemark)
    func erasePendingWaypointAnnotation()
}
