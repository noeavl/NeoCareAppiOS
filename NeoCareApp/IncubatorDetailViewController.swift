//
//  IncubatorDetailViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 27/02/25.
//

import UIKit

class IncubatorDetailViewController: UIViewController {
    var selectedIncubator:Incubator?

    @IBOutlet weak var viewBackgroundStatus: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var viewDetachment: UIView!
    @IBOutlet weak var viewSensors: UIView!
    @IBOutlet weak var lblNurse: UILabel!
    @IBOutlet weak var lblBaby: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backgroundBabyView: UIView!
    @IBOutlet weak var iconBabyView: UIView!
    @IBOutlet weak var labelbabyeView: UIView!
    
    @IBOutlet weak var backgroundNurseView: UIView!
    @IBOutlet weak var iconNurseView: UIView!
    @IBOutlet weak var labelNurseView: UIView!

    @IBOutlet weak var dataButtonView: UIView!
    @IBOutlet weak var incubatorButtonView: UIView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var backgroundDateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let incubator = selectedIncubator {
            if incubator.state == "available" {
                lblNurse.text = "No Nurse"
                lblBaby.text = "No Baby"
            }else{
                lblNurse.text = incubator.nurse
                lblBaby.text = incubator.baby
            }
            lblDate.text = incubator.created_at
            lblId.text = String(incubator.id)
            switch incubator.state.lowercased() {
            case "active":
                viewStatus.backgroundColor = UIColor(named: "rojoBonito")
            case "available":
                viewStatus.backgroundColor = UIColor(named: "verdeBonito")
            default:
                viewStatus.backgroundColor = .gray
            }
            lblState.text = incubator.state
        }
        viewBackgroundStatus.layoutIfNeeded()
        viewBackgroundStatus.roundCorners([.allCorners], 100.0)
        viewStatus.layoutIfNeeded()
        viewStatus.roundCorners([.allCorners], 100.0)
        idView.layoutIfNeeded()
        idView.roundCorners([.topLeft, .bottomLeft], 25.0)
        dateView.layoutIfNeeded()
        dateView.roundCorners([.topRight,.bottomRight], 25.0)
        backgroundDateView.layoutIfNeeded()
        backgroundDateView.roundCorners([.allCorners], 100.0)
        labelbabyeView.layoutIfNeeded()
        labelbabyeView.roundCorners([.topRight,.bottomRight], 25.0)
        iconBabyView.layoutIfNeeded()
        iconBabyView.roundCorners([.topLeft,.bottomLeft], 25.0)
        backgroundBabyView.layoutIfNeeded()
        backgroundBabyView.roundCorners([.allCorners], 100.0)
        iconNurseView.layoutIfNeeded()
        iconNurseView.roundCorners([.topLeft,.bottomLeft], 25.0)
        labelNurseView.layoutIfNeeded()
        labelNurseView.roundCorners([.topRight, .bottomRight], 25.0)
        backgroundNurseView.layoutIfNeeded()
        backgroundNurseView.roundCorners([.allCorners], 100.0)
        viewDetachment.layoutIfNeeded()
        viewDetachment.roundCorners([.allCorners], 100.0)
        viewSensors.layoutIfNeeded()
        viewSensors.roundCorners([.allCorners], 100.0)
        
    }
    
    @IBAction func backButton() {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgIncubatorDetailSensor",
           let destinationVC = segue.destination as? SensorsViewController {
            destinationVC.selectedIncubator = selectedIncubator
        }
    }
    
}
