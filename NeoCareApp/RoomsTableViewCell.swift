//
//  RoomsTableViewCell.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class RoomsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRoomNumber: UIView!
    @IBOutlet weak var lblRoomNumber: UILabel!
    @IBOutlet weak var viewRoomName: UIView!
    @IBOutlet weak var viewRoomIcon: UIView!
    @IBOutlet weak var lblRoomName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewsTopUpdate = [viewRoomNumber,viewRoomName,viewRoomIcon]
        
        viewsTopUpdate.forEach{$0?.layoutIfNeeded()}
       
        viewRoomName.roundCorners([.bottomRight,.topLeft], 20.0)
        viewRoomIcon.roundCorners([.bottomLeft,.topRight], 20.0)
        viewRoomNumber.roundCorners([.allCorners], 20.0)
        lblRoomNumber.roundCorners([.allCorners], 100.0)
    }
}
