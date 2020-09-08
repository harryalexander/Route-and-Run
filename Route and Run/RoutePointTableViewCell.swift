//
//  RoutePointTableViewCell.swift
//  Route and Run
//
//  Created by Harry Alexander on 9/7/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit

class RoutePointTableViewCell: UITableViewCell {
    
    @IBOutlet weak var indicatorView: UIView! {
        didSet {
            self.indicatorView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton! {
        didSet {
            self.button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            self.button.layer.cornerRadius = 4
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
