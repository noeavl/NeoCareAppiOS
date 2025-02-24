//
//  BabyTableViewCell.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 20/02/25.
//

import UIKit

class BabyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblIncubator: UILabel!
    @IBOutlet weak var lblBirthDate: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewInfo.layoutIfNeeded()
        viewInfo.roundCorners([.allCorners], 20.0)
        viewBackground.layoutIfNeeded()
        viewBackground.roundCorners([.allCorners], 20.0)
    }
    
}
