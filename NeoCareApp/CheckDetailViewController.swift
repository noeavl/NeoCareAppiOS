//
//  CheckDetailViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class CheckDetailViewController: UIViewController {
    var selectedCheck: Check?
    @IBOutlet weak var imvNurse: UIImageView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var viewId: UIView!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblBaby: UILabel!
    @IBOutlet weak var lblNurse: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBirthDate: UILabel!
    @IBOutlet weak var viewCheckNurseIcon: UIView!
    @IBOutlet weak var viewCheckNurse: UIView!
    @IBOutlet weak var viewCheckCakeIcon: UIView!
    @IBOutlet weak var viewCheckCake: UIView!
    @IBOutlet weak var viewIconNurse: UIView!
    @IBOutlet weak var viewIconCake: UIView!
    @IBOutlet weak var viewIconDate: UIView!
    @IBOutlet weak var viewCheckDateIcon: UIView!
    @IBOutlet weak var viewCheckDate: UIView!
    @IBOutlet weak var viewCheckTitle: UIView!
    @IBOutlet weak var viewCheckTitleBackground: UIView!
    @IBOutlet weak var viewIconBaby: UIView!
    @IBOutlet weak var viewCheckBabyIcon: UIView!
    @IBOutlet weak var viewCheckBaby: UIView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewDescriptionTitle: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewsToUpdate = [viewDescriptionTitle, viewDescription, viewCheckBaby, viewCheckBabyIcon, viewIconBaby, viewCheckBaby, viewCheckBabyIcon, viewCheckTitle, viewId, viewCheckTitleBackground, viewCheckDateIcon, viewCheckDate, viewIconDate, viewIconCake, viewCheckCakeIcon, viewCheckCake, viewIconCake, viewCheckNurseIcon, viewCheckNurse, viewIconNurse]
        viewsToUpdate.forEach { $0?.layoutIfNeeded() }
        setup()
        
       
        viewDescription.roundCorners([.topRight,.bottomLeft], 20.0)
        viewDescriptionTitle.roundCorners([.bottomRight], 20.0)
        viewCheckBaby.roundCorners([.bottomRight], 20.0)
        viewCheckBabyIcon.roundCorners([.topRight,.bottomRight,.topLeft], 20.0)
        viewIconBaby.roundCorners([.allCorners], 100.0)
        viewCheckTitleBackground.roundCorners([.bottomRight,.bottomLeft], 20.0)
        viewCheckTitle.roundCorners([.bottomRight], 20.0)
        viewCheckDateIcon.roundCorners([.topRight,.topLeft,.bottomRight], 20.0)
        viewCheckDate.roundCorners([.bottomRight], 20.0)
        viewIconDate.roundCorners([.allCorners], 100.0)
        viewIconCake.roundCorners([.allCorners], 100.0)
        viewIconNurse.roundCorners([.allCorners], 100.0)
        viewId.roundCorners([.allCorners], 100.0)
        viewCheckCake.roundCorners([.bottomRight], 20.0)
        viewCheckCakeIcon.roundCorners([.topLeft,.topRight,.bottomRight], 20.0)
        viewCheckNurse.roundCorners([.bottomRight], 20.0)
        viewCheckNurseIcon.roundCorners([.topRight,.topLeft,.bottomRight], 20.0)
     
    }
    
    private func setup(){
        if let check = selectedCheck {
            lblId.text = String(check.check_id)
            lblBirthDate.text = check.baby_date_of_birth
            lblTitle.text = check.title
            if let nurse = check.nurse {
                lblNurse.text = nurse
            }else{
                viewCheckNurseIcon.backgroundColor = .orquidea
                viewCheckNurse.isHidden = true
                viewIconNurse.isHidden = true
                imvNurse.isHidden = true
                lblNurse.isHidden = true
            }
            lblDescription.text = check.description
            lblDate.text = check.created_at
            lblBaby.text = check.baby
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func regresar() {
        dismiss(animated: true)
    }
}
