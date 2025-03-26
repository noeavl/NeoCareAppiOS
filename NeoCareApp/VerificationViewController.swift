//
//  VerificationViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 15/02/25.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txfEmail: UITextField!
    
    var hasStartedTypingEmail = false
    
    let loginEndpoint = "http://127.0.0.1:8000/api/v1/sessions/resend-activation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        btnSend.isEnabled = false
        lblEmailError.isHidden = true

        txfEmail.setPlaceholderColor(.violeta)
        txfEmail.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
        
        txfEmail.addTarget(self, action: #selector(emailDidBeginEditing), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txfEmail.addTarget(self, action: #selector(emailDidEndEditing), for: .editingDidEnd)
    }

    @IBAction func sendEmail() {
    }
    
    @objc func emailDidBeginEditing() {
        hasStartedTypingEmail = true
        lblEmailError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func emailDidEndEditing() {
        // Limpiar error cuando pierde el foco
        lblEmailError.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        
        let emailText = txfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var emailIsValid = false
        
        if hasStartedTypingEmail {
            if emailText.isEmpty {
                lblEmailError.text = "Email is required."
                lblEmailError.isHidden = false
            } else if !isValidEmail(emailText) {
                lblEmailError.text = "The email must be a valid email address."
                lblEmailError.isHidden = false
            } else {
                lblEmailError.isHidden = true
                emailIsValid = true
            }
        }
        
        btnSend.isEnabled = emailIsValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct SendEmailRequest {
    let email: String
    let password: String
}

struct SendEmailResponse {
    let message: String
}


