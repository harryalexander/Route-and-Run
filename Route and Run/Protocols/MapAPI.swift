//
//  MapRequester.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

typealias LocationSearchResult = Result<[MKMapItem], Error>
typealias RouteRequestResult = Result<MKRoute, Error>

protocol MapAPI {
    func requestRouteFromSource(_ source: CLLocationCoordinate2D,
                                toDestination destination: CLLocationCoordinate2D,
                                onCompletion: @escaping(RouteRequestResult) -> Void)
    func sendSearchRequestFor(query: String,
                              onCompletion: @escaping(LocationSearchResult) -> Void)
}
