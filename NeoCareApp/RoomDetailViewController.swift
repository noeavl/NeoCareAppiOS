//
//  RoomDetailViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class RoomDetailViewController: UIViewController {
    var selectedRoom: Room?

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewIconIncubator2: UIView!
    @IBOutlet weak var viewIconIncubator: UIView!
    @IBOutlet weak var viewRow: UIView!
    @IBOutlet weak var viewIncubators: UIView!
    @IBOutlet weak var viewName2: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewID: UIView!
    @IBOutlet weak var viewID2: UIView!
    @IBOutlet weak var viewFecha: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
        viewFecha.roundCorners([.bottomRight], 20)
        viewID2.roundCorners([.bottomLeft, .bottomRight], 20)
        viewID.roundCorners([.allCorners], 100)
        viewName2.roundCorners([.bottomLeft], 20)
        viewName.roundCorners([.bottomRight,.topRight], 20)
        viewIncubators.roundCorners([.bottomLeft,.topRight,.topLeft], 20)
        viewRow.roundCorners([.topRight,.topLeft,.bottomLeft], 20)
        viewIconIncubator.roundCorners([.allCorners], 100)
        viewIconIncubator2.roundCorners([.topLeft,.topRight], 20)
    }
    
    private func setup(){
        if let room = selectedRoom {
            lblName.text = room.name
            lblNumber.text = String(room.number)
            lblDate.text = room.created_at
        }
    }
    
    @IBAction func regresar() {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
