//
//  IncubatorsTableViewCell.swift
//  NeoCareApp
//
//  Created by Noe  on 28/03/25.
//

import UIKit 

class IncubatorsTableViewCell: UITableViewCell {

    @IBOutlet weak var incubatorView: UIView!
    @IBOutlet weak var superViewIncubator: UIView!
    @IBOutlet weak var babyNameView: UIView!
    @IBOutlet weak var nurseNameView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var babyNameLbl: UILabel!
    @IBOutlet weak var nurseNameLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
