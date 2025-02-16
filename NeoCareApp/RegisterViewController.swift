//
//  RegisterViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 15/02/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var pkvHospital: UIPickerView!
    @IBOutlet weak var txfPasswordConfirmation: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfSecondsurname: UITextField!
    @IBOutlet weak var txfFirstsurname: UITextField!
    @IBOutlet weak var txfName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Estilo al placeholder.
        txfName.setPlaceholderColor(.violeta)
        txfFirstsurname.setPlaceholderColor(.violeta)
        txfSecondsurname.setPlaceholderColor(.violeta)
        txfUsername.setPlaceholderColor(.violeta)
        txfEmail.setPlaceholderColor(.violeta)
        txfPassword.setPlaceholderColor(.violeta)
        txfPasswordConfirmation.setPlaceholderColor(.violeta)
        // Estilo al textField
        txfName.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfFirstsurname.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfSecondsurname.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfUsername.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfEmail.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfPassword.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        txfPasswordConfirmation.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
    }

}
