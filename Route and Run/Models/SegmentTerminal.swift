//
//  SegmentTerminal.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

struct SegmentTerminal {
    let source: MKPlacemark
    var destination: MKPlacemark?
    
    init(source: MKPlacemark) {
        self.source = source
        self.destination = nil
    }
    
    init(source: MKPlacemark, destination: MKPlacemark) {
        self.source = source
        self.destination = destination
    }
}
