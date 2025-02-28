//
//  IncubatorsTableTableViewCell.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 26/02/25.
//

import UIKit

class IncubatorsTableTableViewCell: UITableViewCell {


    @IBOutlet weak var incubatorView: UIView!
    
    @IBOutlet weak var babyNameView: UIView!
    @IBOutlet weak var nurseNameView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var babyNameLbl: UILabel!
    @IBOutlet weak var nurseNameLbl: UILabel!
    @IBOutlet weak var addCheckButton: UIButton!
    @IBOutlet weak var contentIncubator: UIView!
    @IBOutlet weak var viewButton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewsToUpdate = [babyNameView, nurseNameView]
        viewsToUpdate.forEach { $0?.layoutIfNeeded() }
        
        incubatorView.layer.cornerRadius = 10.0
        babyNameView.roundCorners([.topRight, .bottomRight], 5.0)
        nurseNameView.roundCorners([.topRight, .bottomRight], 5.0)
        statusView.roundCorners([.topLeft, .bottomLeft], 5.0)
        viewButton.layer.cornerRadius = 10.0
        addCheckButton.layer.cornerRadius = 10.0
    }
}
