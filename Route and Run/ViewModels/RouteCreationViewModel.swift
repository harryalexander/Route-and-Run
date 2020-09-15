//
//  RouteCreationViewModel.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class RouteCreationViewModel: NSObject {
    var startingWaypoint: CLLocationCoordinate2D? {
        guard let waypoint = tappedWaypoints.first else {
            return nil
        }
        return waypoint
    }

    var tappedWaypoints: [CLLocationCoordinate2D] = []
    var hasTappedWaypoints: Bool {
        return !tappedWaypoints.isEmpty
    }
    let mapsService: MapRequester = MapsServiceController()
    let view: RouteCreationViewLayer
    var searchResults: [MKPlacemark] = []
    var isFetchingRouteSection = false
    
    var pendingSegment: SegmentTerminal? {
        didSet {
            guard let pendingSegment = self.pendingSegment else {
                view.erasePendingWaypointAnnotation()
                return
            }
            guard let destination = pendingSegment.destination else {
                view.renderRouteSourceAnnotation(placemark: pendingSegment.source)
                return
            }
            fetchRouteSegment(source: pendingSegment.source, destination: destination)
            
//            if let pendingWaypoint = self.pendingSegment, !routeSegments.isEmpty {
//                view.renderPendingWaypointAnnotation(placemark: pendingWaypoint)
//                fetchRouteSegment()
//            } else {
//                view.erasePendingWaypointAnnotation()
//            }
        }
        
    }
    var routeSegments: [RouteSegment] = []
    
    init(view: RouteCreationViewLayer) {
        self.view = view
        super.init()
    }
    
    func undoLastRouteSegment() {
        if routeSegments.isEmpty {
            view.eraseRouteSourceAnnotation()
            view.setIsUndoButtonEnabled(isEnabled: false)
        } else {
            routeSegments.removeLast()
            view.eraseRouteSegmentWith(index: routeSegments.count)
            view.setIsUndoButtonEnabled(isEnabled: true)
        }
    }
    
    func fetchRouteSegment(source: MKPlacemark, destination: MKPlacemark) {
        mapsService
            .getDirectionsFrom(source: source.coordinate,
                               destination: destination.coordinate) { (route, error) in
            guard error == nil, let route = route else {
                self.view.renderRouteSegmentNetworkingError(error: error!, forDestination: destination.coordinate)
                return
            }
                                let segment = RouteSegment(source: source.coordinate, destination: destination.coordinate, route: route)
            self.routeSegments.append(segment)
            self.view.renderRouteSegment(segment: segment, withIndex: self.routeSegments.count - 1)
        }
    }
    
    func sendSearchRequest(query: String) {
        mapsService.search(query: query) { (response, error) in
            guard error == nil, let response = response else {
                return
            }
            self.searchResults = response.mapItems.map { $0.placemark }
            self.view.renderSearchResults(results: self.searchResults)
        }
    }
    
    func searchResultDescription(result: MKPlacemark) -> String {
        return result.title ?? ""
    }
    
    func pushRoutePoint(placemark: MKPlacemark) {
        if routeSegments.isEmpty, let _ = pendingSegment {
            self.pendingSegment?.destination = placemark
        } else if routeSegments.isEmpty, pendingSegment == nil {
            self.pendingSegment = SegmentTerminal(source: placemark)
        } else if !routeSegments.isEmpty, let source = routeSegments.last?.destination {
            self.pendingSegment = SegmentTerminal(source: MKPlacemark(coordinate: source), destination: placemark)
        }
    }
}
