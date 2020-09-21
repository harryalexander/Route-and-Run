//
//  Route.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/21/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation

struct Route: Codable {
    let name: String
    let segments: [RouteSegment]
    let timeCreated: Date
}
