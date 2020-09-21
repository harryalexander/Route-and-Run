//
//  LocationSearchViewController.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/19/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var useCurrentLocationBarButton: UIBarButtonItem!
    
    let cellReuseID = "LocationSearchTVC"
    var viewModel: LocationSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LocationSearchViewModel(view: self)
    }
    
    func initTableViewCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
        cell.selectionStyle = .blue
        cell.textLabel?.text = text
        return cell
    }
}

extension LocationSearchViewController: LocationSearchView {
    func refresh() {
        tableView.isHidden = viewModel.isTableViewHidden
        tableView.reloadData()
    }
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationDescription = viewModel.labelTextForResultAt(index: indexPath.row) ?? ""
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) else {
            return initTableViewCell(text: locationDescription)
        }
        cell.textLabel?.text = locationDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRowIndex = indexPath.row
        performSegue(withIdentifier: "PresentRouteCreationViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, id == "PresentRouteCreationViewController"  else {
            return
        }
        guard let controller = segue.destination as? RouteCreationViewController else {
            return
        }
        let routeCreationVM = RouteCreationViewModel(view: controller)
        routeCreationVM.source = viewModel.selectedResult
        controller.viewModel = routeCreationVM
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.query = searchBar.text
        viewModel.sendSearchRequest()
    }
}



