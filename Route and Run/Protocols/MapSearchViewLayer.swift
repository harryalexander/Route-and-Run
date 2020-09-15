//
//  MapSearchViewLayer.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

protocol MapSearchViewLayer {
    func renderSearchResults(results: [MKMapItem])
}
