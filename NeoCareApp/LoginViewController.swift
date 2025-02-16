//
//  LoginViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 12/02/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfEmail.setPlaceholderColor(.violeta)
        txfPassword.setPlaceholderColor(.violeta)
        txfEmail.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfPassword.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
    }
}
