//
//  IncubatorDetailViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 27/02/25.
//

import UIKit

class IncubatorDetailViewController: UIViewController {

    @IBOutlet weak var backgroundBabyView: UIView!
    @IBOutlet weak var iconBabyView: UIView!
    @IBOutlet weak var labelbabyeView: UIView!
    
    @IBOutlet weak var backgroundNurseView: UIView!
    @IBOutlet weak var iconNurseView: UIView!
    @IBOutlet weak var labelNurseView: UIView!

    @IBOutlet weak var dataButtonView: UIView!
    @IBOutlet weak var incubatorButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backgroundBabyView.layer.cornerRadius = 30.0
        iconBabyView.layer.cornerRadius = 30.0
        labelbabyeView.layer.cornerRadius = 20.0
        
        backgroundNurseView.layer.cornerRadius = 30.0
        iconNurseView.layer.cornerRadius = 30.0
        labelNurseView.layer.cornerRadius = 20.0
    }
    
    @IBAction func backButton() {
        dismiss(animated: true)
    }
}
