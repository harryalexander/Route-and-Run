//
//  CreateRouteVM.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/7/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol Model {
    func createRoute(name: String, points: [CLLocation])
    func getRoutes() -> [Route]
}

protocol CreateRouteViewModel {
    var points: [CLLocationCoordinate2D] { get }
    func addPointToRoute(point: CLLocationCoordinate2D)
    func startRouteWithCurrentLocation()
    func cellDataForRow(row: Int) -> CreateRouteVM.CellData
}

class CreateRouteVM: NSObject, CLLocationManagerDelegate, MKMapViewDelegate, CreateRouteViewModel {
    struct CellData {
        let id: TableViewCellID
        let showsButton: Bool
        let buttonText: String?
        let locationDescription: String?
    }
    var points: [CLLocationCoordinate2D] = []
    var startsAtCurrentLocation = false
    let directionsController: DirectionsRequester = DirectionsRequestController()
    
//    var start: CLLocationCoordinate2D? {
//        return points.isEmpty ? nil : points.first
//    }
    var routeName: String?
    var isEditingRouteName: Bool = true
    var model: Model?
    var view: CreateRouteView?
    let locationManager = CLLocationManager()
    
    init(view: CreateRouteView) {
        super.init()
        self.view = view
        self.view?.map.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100
    }
    
    func startRouteWithCurrentLocation() {
        points.removeAll()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first, currentLocation.timestamp.timeIntervalSinceNow < 30 else {
            return
        }
        if points.isEmpty {
            points.insert(currentLocation.coordinate, at: 0)
            view?.centerMapAtStart(location: currentLocation.coordinate)
        }
    }
    
    func addPointToRoute(point: CLLocationCoordinate2D) {
        points.append(point)
        if points.count > 1 {
            directionsController.fetchRouteDataBetween(start: points[points.count - 1], destination: points[points.count - 2]) { (route) in
                guard let route = route else {
                    return
                }
                self.view?.map.addOverlay(route.polyline)
            }
        }
    }
    
    func getRoutePoints() -> [CLLocationCoordinate2D] {
        return points
    }
    
    func cellDataForRow(row: Int) -> CellData {
        let point = points[row]
        let data: CellData
        if row == 0, startsAtCurrentLocation {
            data = CellData(id: .routePointTableViewCell, showsButton: true,
                buttonText: "Search for a location",
                locationDescription: "LAT: \(point.latitude)\nLON:\(point.longitude)")
        } else if row == 0, !startsAtCurrentLocation {
            data = CellData(id: .startingLocationSearchTVC, showsButton: true, buttonText: "Start from current location", locationDescription: nil)
        } else {
            data = CellData(id: .routePointTableViewCell, showsButton: false, buttonText: nil, locationDescription: "LAT: \(point.latitude)\nLON:\(point.longitude)")
        }
        return data
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = UIColor.blue
            renderer.fillColor = UIColor.blue
            return renderer
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = UIColor.blue
            renderer.fillColor = UIColor.blue
            return renderer
        }
    }
}
