//
//  HomeViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 26/02/25.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var welcomeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        welcomeView.layer.cornerRadius = 10.0
    }
}
