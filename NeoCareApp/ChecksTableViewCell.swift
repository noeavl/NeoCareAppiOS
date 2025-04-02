//
//  ChecksTableViewCell.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class ChecksTableViewCell: UITableViewCell {
    @IBOutlet weak var iconNurse: UIImageView!
    @IBOutlet weak var viewId: UIView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewIcons: UIView!
    @IBOutlet weak var viewCheck: UIView!
    @IBOutlet weak var lblNurse: UILabel!
    @IBOutlet weak var lblBaby: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewsToUpdate = [viewCheck, viewTitle, viewIcons, viewId]
        viewsToUpdate.forEach { $0?.layoutIfNeeded() }
        
        viewCheck.roundCorners([.topRight,.bottomRight], 20.0)
        viewTitle.roundCorners([.bottomRight], 20.0)
        viewIcons.roundCorners([.topLeft], 20.0)
        viewId.roundCorners([.allCorners], 100.0)
    }
}
