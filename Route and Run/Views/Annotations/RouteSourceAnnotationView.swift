//
//  RouteSourceAnnotationView.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class RouteSourceAnnotationView: MKAnnotationView {
    static let reuseIdentifier = String(describing: RouteSourceAnnotationView.self)
    
    var convertedAnnotation: RouteSourceAnnotation {
        return annotation as! RouteSourceAnnotation
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        guard let _ = annotation as? RouteSourceAnnotation else {
            let message = "\(String(describing: RouteSourceAnnotation.self)) was initialised with an instance of \(String(describing: annotation.self))"
            fatalError(message)
        }
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
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
        layer.borderColor = UIColor.systemGreen.cgColor
        backgroundColor = UIColor.systemGreen
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
