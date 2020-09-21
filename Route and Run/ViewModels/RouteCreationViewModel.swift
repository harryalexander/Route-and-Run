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
    var lastPoint: CLLocationCoordinate2D? {
        return segments.last?.destination ?? source?.placemark.coordinate
    }
    let mapAPI: MapAPI
    var routeName: String?
    var source: MKMapItem?
    var segments: [RouteSegment] = []
    
    let view: RouteCreationViewLayer
    
    init(view: RouteCreationViewLayer) {
        self.mapAPI = AppleMapsService()
        self.view = view
        super.init()
    }
    
    func removeRoutePoint() {
        guard !segments.isEmpty else {
            source = nil
            view.refresh()
            return
        }
        segments.removeAll()
        view.refresh()
    }
    
    func requestRouteTo(destination: CLLocationCoordinate2D) {
        guard let source = lastPoint else {
            return
        }
        mapAPI.requestRouteFromSource(source, toDestination: destination) { (result) in
            switch result {
            case .success(let route):
                let segment = RouteSegment(source: source, destination: destination, route: route)
                self.segments.append(segment)
                self.view.refresh()
            case .failure(_):
                return
            }
        }
    }
    
    func saveRoute() {
        guard let name = routeName, !segments.isEmpty else {
            return
        }
        let route = Route(name: name, segments: segments, timeCreated: Date())
//        let encoder = JSONEncoder()
//        guard let routeData = try? encoder.encode(route) else {
//            return
//        }
        let routeData = try? NSKeyedArchiver.archivedData(withRootObject: route, requiringSecureCoding: true)
        let url = FileManager()
            .urls(for: .documentDirectory,
                  in: .userDomainMask)
            .first!
            .appendingPathComponent("route")
        try! routeData?.write(to: url)
    }
}
