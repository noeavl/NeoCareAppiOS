//
//  RegisterViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 15/02/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var lblHospitalError: UILabel!
    @IBOutlet weak var lblPasswordConfirmationError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblUsernameError: UILabel!
    @IBOutlet weak var lblSecondSurnameError: UILabel!
    @IBOutlet weak var lblFirstSurnameError: UILabel!
    @IBOutlet weak var lblNameError: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var pkvHospital: UIPickerView!
    @IBOutlet weak var txfPasswordConfirmation: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfSecondsurname: UITextField!
    @IBOutlet weak var txfFirstsurname: UITextField!
    @IBOutlet weak var txfName: UITextField!
    
   
    var hasStartedTypingName = false
    var hasStartedTypingFirstSurname = false
    var hasStartedTypingSecondSurname = false
    var hasStartedTypingUsername = false
    var hasStartedTypingEmail = false
    var hasStartedTypingPassword = false
    var hasStartedTypingPasswordConfirm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuraciones iniciales
        btnRegister.isEnabled = false
        lblNameError.isHidden = true
        lblFirstSurnameError.isHidden = true
        lblSecondSurnameError.isHidden = true
        lblUsernameError.isHidden = true
        lblEmailError.isHidden = true
        lblPasswordError.isHidden = true
        lblPasswordConfirmationError.isHidden = true
        lblHospitalError.isHidden = true
        
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
        
        // Observadores para cuando empiece a escribir.
        txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingDidBegin)
        txfFirstsurname.addTarget(self, action: #selector(firstSurnameDidBeginEditing), for: .editingDidBegin)
        txfSecondsurname.addTarget(self, action: #selector(secondSurnameDidBeginEditing), for: .editingDidBegin)
        txfUsername.addTarget(self, action: #selector(usernameDidBeginEditing), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(emailDidBeginEditing), for: .editingDidBegin)
        txfPassword.addTarget(self, action: #selector(passwordDidBeginEditing), for: .editingDidBegin)
        txfPasswordConfirmation.addTarget(self, action: #selector(passwordConfirmDidBeginEditing), for: .editingDidBegin)
        // Oservadores mienstras escribe.
        txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingChanged)
        txfFirstsurname.addTarget(self, action: #selector(firstSurnameDidBeginEditing), for: .editingChanged)
        txfSecondsurname.addTarget(self, action: #selector(secondSurnameDidBeginEditing), for: .editingChanged)
        txfUsername.addTarget(self, action: #selector(usernameDidBeginEditing), for: .editingChanged)
        txfEmail.addTarget(self, action: #selector(emailDidBeginEditing), for: .editingChanged)
        txfPassword.addTarget(self, action: #selector(passwordDidBeginEditing), for: .editingChanged)
        txfPasswordConfirmation.addTarget(self, action: #selector(passwordConfirmDidBeginEditing), for: .editingChanged)
        // Obserdaores cuando termina de escribir.
        txfName.addTarget(self, action: #selector(nameDidEndEditing), for: .editingDidEnd)
        txfFirstsurname.addTarget(self, action: #selector(firstSurnameDidEndEditing), for: .editingDidEnd)
        txfSecondsurname.addTarget(self, action: #selector(secondSurnameDidEndEditing), for: .editingDidEnd)
        txfUsername.addTarget(self, action: #selector(usernameDidEndEditing), for: .editingDidEnd)
        txfEmail.addTarget(self, action: #selector(emailDidEndEditing), for: .editingDidEnd)
        txfPassword.addTarget(self, action: #selector(passwordDidEndEditing), for: .editingDidEnd)
        txfPasswordConfirmation.addTarget(self, action: #selector(passwordConfirmDidEndEditing), for: .editingDidEnd)
    }

    @IBAction func register() {
    }
    
    @objc func nameDidBeginEditing() {
        hasStartedTypingName = true
        lblNameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func firstSurnameDidBeginEditing() {
        hasStartedTypingFirstSurname = true
        lblFirstSurnameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func secondSurnameDidBeginEditing() {
        hasStartedTypingSecondSurname = true
        lblSecondSurnameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func usernameDidBeginEditing() {
        hasStartedTypingUsername = true
        lblUsernameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func emailDidBeginEditing() {
        hasStartedTypingEmail = true
        lblEmailError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func passwordDidBeginEditing() {
        hasStartedTypingPassword = true
        lblPasswordError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func passwordConfirmDidBeginEditing() {
        hasStartedTypingPasswordConfirm = true
        lblPasswordConfirmationError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func nameDidEndEditing() {
        lblNameError.isHidden = true
    }
    
    @objc func firstSurnameDidEndEditing() {
        lblFirstSurnameError.isHidden = true
    }
    
    @objc func secondSurnameDidEndEditing() {
        lblSecondSurnameError.isHidden = true
    }
    
    @objc func usernameDidEndEditing() {
        lblUsernameError.isHidden = true
    }
    
    @objc func emailDidEndEditing() {
        lblEmailError.isHidden = true
    }
    
    @objc func passwordDidEndEditing() {
        lblPasswordError.isHidden = true
    }
    
    @objc func passwordConfirmDidEndEditing() {
        lblPasswordConfirmationError.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        
        
        let nameText = txfName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let firstSurnameText = txfFirstsurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let secondSurnameText = txfSecondsurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let usernameText = txfUsername.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let emailText = txfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let passwordText = txfPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let passwordConfirmationText = txfPasswordConfirmation.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var nameIsValid = false
        var firstSurnameIsValid = false
        var secondSurnameIsValid = false
        var usernameIsValid = false
        var emailIsValid = false
        var passwordIsValid = false
        var passwordConfirmIsValid = false
      
        
        if hasStartedTypingName {
            if nameText.isEmpty {
                lblNameError.text = "Name is required."
                lblNameError.isHidden = false
            } else if nameText.count > 49 {
                lblNameError.text = "Name must be less than 50 characters."
                lblNameError.isHidden = false
            } else {
                lblNameError.isHidden = true
                nameIsValid = true
            }
        }
        
        if hasStartedTypingFirstSurname {
            if firstSurnameText.isEmpty {
                lblFirstSurnameError.text = "First surname is required."
                lblFirstSurnameError.isHidden = false
            } else if firstSurnameText.count > 49 {
                lblFirstSurnameError.text = "First surname must be less than 50 characters."
                lblFirstSurnameError.isHidden = false
            } else {
                lblFirstSurnameError.isHidden = true
                firstSurnameIsValid = true
            }
        }
        
        if hasStartedTypingSecondSurname {
            if secondSurnameText.count > 49 {
                lblSecondSurnameError.text = "Second surname must be less than 50 characters."
                lblSecondSurnameError.isHidden = false
            } else {
                lblSecondSurnameError.isHidden = true
                secondSurnameIsValid = true
            }
        }
        
        if hasStartedTypingUsername {
            if usernameText.isEmpty {
                lblUsernameError.text = "Username is required."
                lblUsernameError.isHidden = false
            } else if usernameText.count > 49 {
                lblUsernameError.text = "Username must be less than 50 characters."
                lblUsernameError.isHidden = false
            } else {
                lblUsernameError.isHidden = true
                usernameIsValid = true
            }
        }
        
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
        
        if hasStartedTypingPassword {
            if passwordText.isEmpty {
                lblPasswordError.text = "Password is required."
                lblPasswordError.isHidden = false
            } else if passwordText.count < 8 {
                lblPasswordError.text = "Password must be at least 8 characters."
                lblPasswordError.isHidden = false
            } else if passwordText != passwordConfirmationText{
                lblPasswordError.text = "Passwords do not match."
                lblPasswordError.isHidden = false
            }else {
                lblPasswordError.isHidden = true
                passwordIsValid = true
            }
        }
        
        if hasStartedTypingPasswordConfirm{
            if passwordConfirmationText.isEmpty {
                lblPasswordConfirmationError.text = "Password Confirm is required."
                lblPasswordConfirmationError.isHidden = false
            } else {
                lblPasswordConfirmationError.isHidden = true
                passwordConfirmIsValid = true
            }
        }
        
        btnRegister.isEnabled = nameIsValid && firstSurnameIsValid && secondSurnameIsValid && usernameIsValid && emailIsValid && passwordIsValid && passwordConfirmIsValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct RegisterRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let message: String
}


