//
//  RouteCreationViewController.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/9/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit
import MapKit

class RouteCreationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
        }
    }
    @IBOutlet weak var saveRouteButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var undoBarButton: UIBarButtonItem!
    
    var viewModel: RouteCreationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RouteCreationViewModel(view: self)
        configureRouteEditBarButton(button: self.undoBarButton)
    }
    
    @IBAction func mapViewTapped(sender: UITapGestureRecognizer) {
        sender.isEnabled = false
        let viewCoordinate = sender.location(in: mapView)
        let mapCoordinate = mapView.convert(viewCoordinate, toCoordinateFrom: mapView)
        let placemark = MKPlacemark(coordinate: mapCoordinate)
        viewModel.pushRoutePoint(placemark: placemark)
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func undoButtonTapped(sender: UIBarButtonItem) {
        viewModel.undoLastRouteSegment()
    }
    
    func configureRouteEditBarButton(button: UIBarButtonItem) {
        let font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)!
        let textAttributes = [NSAttributedString.Key.font: font]
        self.undoBarButton.setTitleTextAttributes(textAttributes, for: .normal)
        undoBarButton.isEnabled = false
    }
    
    func renderTableView(placemarks: MKPlacemark?) {
        UIView.animate(withDuration: 0.20) {
            self.mapView.alpha = 0
            self.mapView.isHidden = true
        }
    }
    
    func renderMapView() {
        UIView.animate(withDuration: 0.20) {
            self.mapView.isHidden = false
            self.mapView.alpha = 1
        }
    }
    
    func centerAndZoomInOn(location: CLLocationCoordinate2D) {
        let lat = location.latitude + 0.000900
        let lon = location.longitude - 0.000900
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: ViewLayer Implementations
extension RouteCreationViewController: RouteCreationViewLayer {
    func setIsUndoButtonEnabled(isEnabled: Bool) {
        undoBarButton.isEnabled = isEnabled
    }
    
    func renderSearchResults(results: [MKPlacemark]) {
        tableView.reloadData()
    }
    
    func renderRouteSourceAnnotation(placemark: MKPlacemark) {
        centerAndZoomInOn(location: placemark.coordinate)
        let annotation = RouteSourceAnnotation(index: 0, placemark: placemark)
        mapView.addAnnotation(annotation)
    }
    
    func eraseRouteSourceAnnotation() {
        let annotations = mapView.annotations
            .filter { $0.self is RouteSourceAnnotation }
        mapView.removeAnnotations(annotations)
    }
    
    func renderRouteSegment(segment: RouteSegment, withIndex index: Int) {
        let destinationAnnotation = RouteSegmentEndpointAnnotation(
            index: index,
            coordinate: segment.destination)
        mapView.addAnnotation(destinationAnnotation)
        
        let overlay = RouteSegmentOverlay(index: index, segment: segment)
        mapView.addOverlay(overlay)
    }
    
    func eraseRouteSegmentWith(index: Int) {
        let annotations = mapView.annotations
            .filter { $0.self is RouteSegmentEndpointAnnotation &&
                ($0 as! RouteSegmentEndpointAnnotation).index == index }
        let overlays = mapView.overlays
            .filter { $0.self is RouteSegmentOverlay &&
                ($0 as! RouteSegmentOverlay).index == index
        }
        mapView.removeAnnotations(annotations)
        mapView.removeOverlays(overlays)
        guard !mapView.overlays.isEmpty else {
            mapView.removeAnnotations(mapView.annotations)
            return
        }
    }
    
    func renderRouteSegmentNetworkingError(error: Error, forDestination destination: CLLocationCoordinate2D) {
        let annotation = ErrorAnnotation(errorMessage: error.localizedDescription, coordinate: destination)
        mapView.addAnnotation(annotation)
    }
    
    func renderPendingWaypointAnnotation(placemark: MKPlacemark) {
        let annotation = PendingWaypointAnnotation(placemark: placemark)
        mapView.addAnnotation(annotation)
    }
    
    func erasePendingWaypointAnnotation() {
        let pendingWaypointAnnotations = mapView
            .annotations
            .filter { $0.self is PendingWaypointAnnotation }
        mapView.removeAnnotations(pendingWaypointAnnotations)
    }
}

// MARK: MapView Delegate Extension
extension RouteCreationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MapOverlay else {
            return MKOverlayRenderer()
        }
        return overlay.renderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView
        switch annotation.self {
        case is ErrorAnnotation:
            view = ErrorAnnotationView(annotation: annotation,
                                       reuseIdentifier: ErrorAnnotationView.reuseIdentifier)
        case is PendingWaypointAnnotation:
            view = PendingWaypointAnnotationView(annotation: annotation,
                                                 reuseIdentifier: PendingWaypointAnnotationView.reuseIdentifier)
        case is RouteSourceAnnotation:
            view = RouteSourceAnnotationView(annotation: annotation,
                                             reuseIdentifier: RouteSourceAnnotationView.reuseIdentifier)
        default:
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "StartAnnotationView")
            pinView.pinTintColor = UIColor.systemGreen
            pinView.canShowCallout = true
            
            return pinView
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.setSelected(true, animated: true)
        }
    }
}

// MARK: UISearchBar Delegate
extension RouteCreationViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        renderTableView(placemarks: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.sendSearchRequest(query: query)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        renderMapView()
    }
}

// MARK: UITableView Delegate and DataSource
extension RouteCreationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchTableViewCell") as! LocationSearchResultTableViewCell
        let searchResult = viewModel.searchResults[indexPath.row]
        cell.locationDescriptionLabel?.text = viewModel.searchResultDescription(result: searchResult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        renderMapView()
        let selectedResult = viewModel.searchResults[indexPath.row]
        viewModel.pushRoutePoint(placemark: selectedResult)
        searchBar.text = nil
    }
}
