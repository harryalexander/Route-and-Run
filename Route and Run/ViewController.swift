//
//  ViewController.swift
//  Route and Run
//
//  Created by Harry Alexander on 8/30/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CreateRouteView, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapTapRecogniser: UITapGestureRecognizer!
    
    var viewModel: CreateRouteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.map.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel = CreateRouteVM(view: self)
        viewModel?.startRouteWithCurrentLocation()
    }
    
    func centerMapAtStart(location: CLLocationCoordinate2D) {
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
    }
    
    @IBAction func handleMapTap(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: map)
        let mapPoint = map.convert(point, toCoordinateFrom: map)
        viewModel?.addPointToRoute(point: mapPoint)
        tableView.reloadData()
        // let routes = viewModel?.getRoutePoints() ?? []
        let circleOverlay = MKCircle(center: mapPoint, radius: 2)
        map.addOverlay(circleOverlay)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numPoints = viewModel?.points.count, numPoints > 0 else {
            return 1
        }
        return numPoints
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel?.cellDataForRow(row: indexPath.row) else {
            return UITableViewCell()
        }
        switch data.id {
        case .startingLocationSearchTVC:
            let cell = tableView.dequeueReusableCell(withIdentifier: data.id.rawValue) as! StartingLocationSearchTVC
            cell.button.setTitle(data.buttonText, for: .normal)
            cell.button.isHidden = !data.showsButton
            
            return cell
        case .routePointTableViewCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: data.id.rawValue) as! RoutePointTableViewCell
            cell.button.setTitle(data.buttonText, for: .normal)
            cell.button.isHidden = !data.showsButton
            cell.label.text = data.locationDescription
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewCell()
        view.textLabel?.textColor = UIColor.darkText
        view.textLabel?.text = "Points"
        return view
    }
    
    
}
