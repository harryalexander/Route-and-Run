//
//  PendingWaypointAnnotationView.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class PendingWaypointAnnotationView: MKAnnotationView {
    static let reuseIdentifier = String(describing: PendingWaypointAnnotationView.self)
    
    var convertedAnnotation: PendingWaypointAnnotation {
        return annotation as! PendingWaypointAnnotation
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        guard let _ = annotation as? PendingWaypointAnnotation else {
            let message = "\(String(describing: PendingWaypointAnnotationView.self)) was initialised with an instance of \(String(describing: annotation.self))"
            fatalError(message)
        }
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.frame.size.width = 20
        self.frame.size.height = 20
        self.isOpaque = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemBlue.cgColor
        backgroundColor = UIColor(white: 0, alpha: 0)
        canShowCallout = true
        addErrorMessageLabel(message: convertedAnnotation.message)
    }
    
    func addErrorMessageLabel(message: String) {
        let messageLabel = UILabel()
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        detailCalloutAccessoryView = messageLabel
    }
}
