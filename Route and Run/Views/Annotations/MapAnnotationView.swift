//
//  MapAnnotationView.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/19/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import MapKit

class MapAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        let mapAnnotation = annotation as! MapAnnotation
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(annotationType: mapAnnotation.annotationType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(annotationType: MapAnnotation.AnnotationType) {
        switch annotationType {
        case .source:
            configureWith(color: UIColor.systemGreen)
        case .intermediate:
            configureWith(color: UIColor.systemBlue)
        case .destination:
            configureWith(color: UIColor.systemRed)
        }
    }
    
    func configureWith(color: UIColor) {
        self.frame.size.width = 16
        self.frame.size.height = 16
        self.isOpaque = false
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
        backgroundColor = color
        canShowCallout = true
    }
    
    func addTitleLabel(message: String) {
        let messageLabel = UILabel()
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        detailCalloutAccessoryView = messageLabel
    }
}
