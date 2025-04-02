//
//  IncubatorDetailViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 27/02/25.
//

import UIKit

class IncubatorDetailViewController: UIViewController {
    var selectedIncubator:Incubator?

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

        lblNurse.text = selectedIncubator?.nurseName
        lblBaby.text = selectedIncubator?.babyName
        lblDate.text = selectedIncubator?.created_at
        
        backgroundBabyView.roundCorners([.allCorners], 100.0)
        labelbabyeView.layer.cornerRadius = 32.0
        backgroundNurseView.layer.cornerRadius = 38.0
        labelNurseView.layer.cornerRadius = 32.0
        idView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], 100.0)
        backgroundDateView.roundCorners([.topLeft,.topLeft, .bottomLeft, .bottomRight], 100.0)
        idView.roundCorners([.allCorners], 100.0)

        func makeCircular(_ view: UIView) {
                let size = min(view.frame.width, view.frame.height)
                view.layer.cornerRadius = size / 2
                view.clipsToBounds = true
                view.layer.masksToBounds = true
            }

        makeCircular(iconBabyView)
        makeCircular(iconNurseView)
        makeCircular(dateView)
        makeCircular(dataButtonView)
        makeCircular(incubatorButtonView)
    }
    
    @IBAction func backButton() {
        dismiss(animated: true)
    }
}
