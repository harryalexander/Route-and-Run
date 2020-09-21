//
//  MapAnnotation.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/18/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import  MapKit

class MapAnnotation: NSObject, MKAnnotation {
    enum AnnotationType {
        case source
        case intermediate
        case destination
    }
    
    var annotationType: AnnotationType
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    
    init(type: AnnotationType, coordinate: CLLocationCoordinate2D) {
        self.annotationType = type
        self.coordinate = coordinate
    }
    
    func renderer() -> MKCircleRenderer {
        let renderer = MKCircleRenderer()
        switch annotationType {
        case .source:
            renderer.strokeColor = UIColor.green
            renderer.fillColor = UIColor.green
            renderer.lineWidth = 1
        default:
            return MKCircleRenderer()
        }
        return renderer
    }
}
