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
    @IBOutlet weak var routeNameTextField: UITextField! {
        didSet {
            self.routeNameTextField.keyboardType = .alphabet
        }
    }
    
    var viewModel: RouteCreationViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        zoomInOnSource()
    }
    
    @IBAction func mapViewTapped(sender: UITapGestureRecognizer) {
        routeNameTextField.resignFirstResponder()
        let viewCoordinate = sender.location(in: mapView)
        let mapCoordinate = mapView.convert(viewCoordinate,
                                            toCoordinateFrom: mapView)
        viewModel.requestRouteTo(destination: mapCoordinate)
    }
    
    @IBAction func undoButtonTapped(sender: UIButton) {
        viewModel.removeRoutePoint()
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        routeNameTextField.endEditing(false)
        viewModel.saveRoute()
    }
    
    func centerAndZoomInOn(location: CLLocationCoordinate2D) {
        let lat = location.latitude + 0.000900
        let lon = location.longitude - 0.000900
        let center = CLLocationCoordinate2D(latitude: lat,
                                            longitude: lon)
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 250,
                                        longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)
    }
    
    func zoomInOnSource() {
        guard let location = viewModel.source?.placemark.coordinate else {
            return
        }
        centerAndZoomInOn(location: location)
    }
}

// MARK: ViewLayer Extensions
extension RouteCreationViewController: RouteCreationViewLayer {
    func refresh() {
        guard let source = viewModel.source else {
            return
        }
        let annotation = MapAnnotation(type: .source, coordinate: source.placemark.coordinate)
        mapView.addAnnotation(annotation)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let annotations = viewModel.segments.enumerated().map {
            $0.offset == viewModel.segments.endIndex - 1 ?
                MapAnnotation(type: .destination, coordinate: $0.element.destination) :
                MapAnnotation(type: .intermediate, coordinate: $0.element.destination) }
        mapView.addAnnotations(annotations)
        
        let overlays = viewModel.segments.compactMap { $0.polyline }
        mapView.addOverlays(overlays)
    }
}

// MARK: MapView Delegate Extension
extension RouteCreationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.fillColor = UIColor.systemBlue
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineCap = .round
        renderer.lineJoin = .round
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MapAnnotationView(annotation: annotation, reuseIdentifier: nil)
        return view
    }
}

extension RouteCreationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch reason {
        case .committed:
            viewModel.routeName = textField.text
        default:
            return
        }
    }
}
