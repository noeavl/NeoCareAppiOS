//
//  FamiliarTableViewCell.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 24/02/25.
//

import UIKit

class FamiliarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewInfo.layoutIfNeeded()
        viewInfo.roundCorners([.allCorners], 20.0)
        
        viewBackground.layoutIfNeeded()
        viewBackground.roundCorners([.allCorners], 20.00)
    }
}
