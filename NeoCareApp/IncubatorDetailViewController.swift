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
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var backgroundDateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundBabyView.layer.cornerRadius = 38.0
        labelbabyeView.layer.cornerRadius = 32.0
        backgroundNurseView.layer.cornerRadius = 38.0
        labelNurseView.layer.cornerRadius = 32.0
        backgroundDateView.layer.cornerRadius = 38.0

        func makeCircular(_ view: UIView) {
                let size = min(view.frame.width, view.frame.height) // Asegurar tamaño cuadrado
                view.layer.cornerRadius = size / 2
                view.clipsToBounds = true
                view.layer.masksToBounds = true // Suavizar bordes
            }

        makeCircular(iconBabyView)
        makeCircular(iconNurseView)
        makeCircular(dateView)
        makeCircular(idView)
        makeCircular(dataButtonView)
        makeCircular(incubatorButtonView)
    }
    
    @IBAction func backButton() {
        dismiss(animated: true)
    }
}
