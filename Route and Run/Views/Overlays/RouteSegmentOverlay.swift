//
//  RouteSectionRenderer.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/10/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class RouteSegmentOverlay: MKPolyline {
    var index: Int
    var segment: RouteSegment
    
    override var pointCount: Int {
        return self.segment.polyline.pointCount
    }
    
    init(index: Int, segment: RouteSegment) {
        self.index = index
        self.segment = segment
        super.init()
    }
    
    override func points() -> UnsafeMutablePointer<MKMapPoint> {
        return segment.polyline.points()
    }
}

extension RouteSegmentOverlay: MapOverlay {
    
    func renderer() -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: self)
        renderer.lineWidth = 5
        renderer.strokeColor = UIColor.systemBlue
        renderer.fillColor = UIColor.systemBlue
        
        return renderer
    }
}
