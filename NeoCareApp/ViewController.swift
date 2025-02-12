//
//  ViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 23/01/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txfEmail.layer.cornerRadius = 20
    }

}

