//
//  RouteSection.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

struct RouteSegment: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case distance
        case source
        case destination
    }
    let distance: CLLocationDistance
    let source: CLLocationCoordinate2D
    let destination: CLLocationCoordinate2D
    let polyline: MKPolyline?
    
    init(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, route: MKRoute) {
        self.distance = route.distance
        self.source = source
        self.destination = destination
        self.polyline = route.polyline
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(distance, forKey: .distance)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(destination, forKey: .destination)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        distance = try container.decode(CLLocationDistance.self, forKey: .distance)
        source = try container.decode(CLLocationCoordinate2D.self, forKey: .source)
        destination = try container.decode(CLLocationCoordinate2D.self, forKey: .destination)
        polyline = nil
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude, longtitude
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longtitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longtitude)
    }
}
