//
//  RegisterViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 15/02/25.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
    var hospitals: [Hospital] = []
    var selectedHospital: Hospital? = nil
    var hospitalPlaceholder = "Select a Hospital"
    
    var hasStartedTypingName = false
    var hasStartedTypingFirstSurname = false
    var hasStartedTypingSecondSurname = false
    var hasStartedTypingUsername = false
    var hasStartedTypingEmail = false
    var hasStartedTypingPassword = false
    var hasStartedTypingPasswordConfirm = false
    
    let registerEndPoint = "http://34.215.209.108/api/v1/sessions/register-app"
    let hospitalsNoPaginateEndPoint = "http://34.215.209.108/api/v1/hospitalsNoPaginate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        getHospitals()
        
        pkvHospital.delegate = self
        pkvHospital.dataSource = self
        
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
        view.endEditing(true)
        
        guard let name =
                txfName.text?.trimmingCharacters(in: .whitespaces),
              let firstName =
              txfFirstsurname.text?.trimmingCharacters(in: .whitespaces),
              let secondName =
              txfSecondsurname.text?.trimmingCharacters(in: .whitespaces),
              let username =
              txfUsername.text?.trimmingCharacters(in: .whitespaces),
              let email =
              txfEmail.text?.trimmingCharacters(in: .whitespaces),
              let password = txfPassword.text?.trimmingCharacters(in: .whitespaces),
              let passwordConfirmation = txfPasswordConfirmation.text?.trimmingCharacters(in: .whitespaces),
              let hospital = selectedHospital else {
                showError(message: "Validation errors, please review the form.")
                return
            }
        
        
        showLoadingIndicator()
        
        let registerRequest = RegisterRequest(name: name, last_name_1: firstName, last_name_2: secondName, username: username, email: email, password: password, password_confirmation: passwordConfirmation, hospital_id:hospital.id )
        do {
            let request = try createURLRequest(for: registerRequest)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                self?.hideLoadingIndicator()
            
                if let error = error {
                    self?.showError(message: "Network Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showError(message: "Invalid Response.")
                    return
                }
                
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 201:
                        // Restablecer los valores.
                        self?.txfName.text = ""
                        self?.txfFirstsurname.text = ""
                        self?.txfSecondsurname.text = ""
                        self?.txfUsername.text = ""
                        self?.txfEmail.text = ""
                        self?.txfPassword.text = ""
                        self?.txfPasswordConfirmation.text = ""
                        self?.pkvHospital.selectRow(0, inComponent: 0, animated: true)
                        self?.selectedHospital = nil
                        self?.lblNameError.isHidden = true
                        self?.lblFirstSurnameError.isHidden = true
                        self?.lblSecondSurnameError.isHidden = true
                        self?.lblUsernameError.isHidden = true
                        self?.lblPasswordError.isHidden = true
                        self?.lblPasswordConfirmationError.isHidden = true
                        self?.btnRegister.isEnabled = false
                        self?.view.endEditing(true)
                        self?.handleSuccessResponse(data: data)
                    case 422:
                        if let data = data {
                                self?.handleValidationErrors(data: data)
                            } else {
                                self?.showError(message: "Validation errors, please review the form.")
                            }
                    default:
                        self?.showError(message: "Unknown Error.")
                    }
                    print(httpResponse)
                }
            }.resume()
            
        } catch {
            hideLoadingIndicator()
            showError(message: "Error creating the request.")
        }
    }
    
    private func handleValidationErrors(data: Data) {
        do {
            // Decodificar el JSON de errores
            let errors = try JSONDecoder().decode([String: [String]].self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                // Limpiar errores previos
                self?.lblNameError.isHidden = true
                self?.lblFirstSurnameError.isHidden = true
                self?.lblSecondSurnameError.isHidden = true
                self?.lblUsernameError.isHidden = true
                self?.lblEmailError.isHidden = true
                self?.lblPasswordError.isHidden = true
                self?.lblPasswordConfirmationError.isHidden = true
                self?.lblHospitalError.isHidden = true
                
                // Mostrar errores por campo
                if let nameErrors = errors["name"]?.joined(separator: "\n") {
                    self?.lblNameError.text = nameErrors
                    self?.lblNameError.isHidden = false
                }
                
                if let firstNameErrors = errors["last_name_1"]?.joined(separator: "\n") {
                    self?.lblFirstSurnameError.text = firstNameErrors
                    self?.lblFirstSurnameError.isHidden = false
                }
                
                if let secondNameErrors = errors["last_name_2"]?.joined(separator: "\n") {
                    self?.lblSecondSurnameError.text = secondNameErrors
                    self?.lblSecondSurnameError.isHidden = false
                }
                
                if let usernameErrors = errors["username"]?.joined(separator: "\n") {
                    self?.lblUsernameError.text = usernameErrors
                    self?.lblUsernameError.isHidden = false
                }
                
                if let emailErrors = errors["email"]?.joined(separator: "\n") {
                    self?.lblEmailError.text = emailErrors
                    self?.lblEmailError.isHidden = false
                }
                
                if let passwordErrors = errors["password"]?.joined(separator: "\n") {
                    self?.lblPasswordError.text = passwordErrors
                    self?.lblPasswordError.isHidden = false
                }
            }
        } catch {
            showError(message: "Validation errors, please review the form.")
        }
    }
    
    private func handleSuccessResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
            let alert = UIAlertController(
                title: "Success",
                message: registerResponse.message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func handleSuccessResponseHospitals(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let hospitalsResponse = try JSONDecoder().decode(HospitalsResponse.self, from: data)
            hospitals = hospitalsResponse.hospitals
            DispatchQueue.main.async {
                self.pkvHospital.reloadAllComponents()
                self.textFieldDidChange()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
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
        var hospitalIsValid = false
      
        
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
        
        if selectedHospital != nil {
            lblHospitalError.isHidden = true
            hospitalIsValid = true
        } else {
            lblHospitalError.text = "Please select a hospital"
            lblHospitalError.isHidden = false
            hospitalIsValid = false
        }
        let hospitalsLoaded = !hospitals.isEmpty
        hospitalIsValid = hospitalsLoaded && selectedHospital != nil
        
        btnRegister.isEnabled = nameIsValid && firstSurnameIsValid && secondSurnameIsValid && usernameIsValid && emailIsValid && passwordIsValid && passwordConfirmIsValid && hospitalIsValid && hospitalsLoaded
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hospitals.isEmpty ? 1 : hospitals.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if hospitals.isEmpty{
            return "Loading Hospitals..."
        }
        return row == 0 ? hospitalPlaceholder : hospitals[row - 1].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
                // No hacer nada si selecciona el placeholder
                selectedHospital = nil
            } else {
                selectedHospital = hospitals[row - 1] // Ajustar índice
            }
            textFieldDidChange()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            
            self.lblNameError.isHidden = true
            self.lblFirstSurnameError.isHidden = true
            self.lblSecondSurnameError.isHidden = true
            self.lblUsernameError.isHidden = true
            self.lblEmailError.isHidden = true
            self.lblPasswordError.isHidden = true
            self.lblPasswordConfirmationError.isHidden = true
            
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    private func showLoadingIndicator() {
        btnRegister.configuration?.showsActivityIndicator = true
        btnRegister.isEnabled = false
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.btnRegister.configuration?.showsActivityIndicator = false
            self.btnRegister.isEnabled = true
        }
    }
    
    private func createURLRequest(for registerRequest: RegisterRequest) throws -> URLRequest {
        guard let url = URL(string: registerEndPoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(registerRequest)
        
        return request
    }
    
    private func createURLRequestHospitals() throws -> URLRequest {
        guard let url = URL(string:hospitalsNoPaginateEndPoint ) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func getHospitals(){
        do{
            let request = try createURLRequestHospitals()
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                self?.hideLoadingIndicator()
                
                if let error = error {
                    self?.showError(message: "Network Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showError(message: "Invalid Response.")
                    return
                }
                
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 200...299:
                        self?.handleSuccessResponseHospitals(data: data)
                    default:
                        self?.showError(message: "Unkown Error")
                    }
                }
            }.resume()
        } catch {
            hideLoadingIndicator()
            showError(message: "Error creating the request.")
        }
    }
}

struct RegisterRequest: Encodable {
    let name: String
    let last_name_1:String
    let last_name_2:String
    let username: String
    let email: String
    let password: String
    let password_confirmation: String
    let hospital_id:Int
}
struct HospitalsResponse: Decodable {
    let message : String
    let hospitals: [Hospital]
}
struct RegisterResponse: Decodable {
    let message: String
}

struct Hospital :Decodable {
    let id:Int
    let name:String
}

