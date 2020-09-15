//
//  ErrorAnnotationView.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/14/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import Foundation
import MapKit

class ErrorAnnotationView: MKAnnotationView {
    static let reuseIdentifier = String(describing: ErrorAnnotationView.self)
        
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        guard let _ = annotation as? ErrorAnnotation else {
            let message = "\(String(describing: ErrorAnnotationView.self)) was initialised with an instance of \(String(describing: annotation.self))"
            fatalError(message)
        }
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
        setNeedsDisplay()
    }
    
    func configure() {
        self.frame.size.width = 20
        self.frame.size.height = 20
        self.isOpaque = false
        layer.cornerRadius = 10
        backgroundColor = UIColor(white: 0, alpha: 0)
        canShowCallout = true
        // This is forcefully unwrapped since I would like this view to only hold
        // instances of ErrorAnnotation. If it receives something else, I'd rather
        // it crash during development.
        let annotation = self.annotation as! ErrorAnnotation
        addErrorMessageLabel(message: annotation.errorMessage)
        addDismissButton()
    }
    
    func addErrorMessageLabel(message: String) {
        let messageLabel = UILabel()
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        detailCalloutAccessoryView = messageLabel
    }
    
    func addDismissButton() {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.sizeToFit()
        rightCalloutAccessoryView = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
