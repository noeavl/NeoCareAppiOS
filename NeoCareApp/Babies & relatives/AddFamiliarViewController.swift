//
//  AddFamiliarViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class AddFamiliarViewController: UIViewController {
    
    @IBOutlet weak var lblNameError: UILabel!
    
    @IBOutlet weak var lblFatherError: UILabel!
    
    @IBOutlet weak var lblMotherError: UILabel!
    
    @IBOutlet weak var lblPhoneError: UILabel!
    
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var txfName: UITextField!
    
    @IBOutlet weak var txfFatherSurname: UITextField!
    
    @IBOutlet weak var txfMotherSurname: UITextField!
    
    @IBOutlet weak var txfPhone: UITextField!
    
    @IBOutlet weak var txfEmail: UITextField!
    
    
    @IBOutlet weak var btnCreate: UIButton!
    
    var hasStartedTypingName = false
       var hasStartedTypingBirthdate = false
       var hasStartedTypingMother = false
       var hasStartedTypingFather = false
    
    let relativesEndpoint = "http://34.215.209.108/api/v1/relatives"
    
    
    var babyID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        btnCreate.isEnabled = false
        lblNameError.isHidden = true
        lblPhoneError.isHidden = true
        lblMotherError.isHidden = true
        lblFatherError.isHidden = true
        lblEmailError.isHidden = true
        
        txfName.setPlaceholderColor(.violeta)
        txfPhone.setPlaceholderColor(.violeta)
        txfMotherSurname.setPlaceholderColor(.violeta)
        txfFatherSurname.setPlaceholderColor(.violeta)
        txfEmail.setPlaceholderColor(.violeta)
        
        
        txfName.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfPhone.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfMotherSurname.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfFatherSurname.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfEmail.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        
        txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingDidBegin)
        txfPhone.addTarget(self, action: #selector(phoneDidBeginEditing), for: .editingDidBegin)
        txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidBeginEditing), for: .editingDidBegin)
        txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidBeginEditing), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(emailDidBeginEditing), for: .editingDidBegin)
        
        txfName.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        txfPhone.addTarget(self, action: #selector(phoneDidChange), for: .editingChanged)
        txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidChange), for: .editingChanged)
        txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidChange), for: .editingChanged)
        txfEmail.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        
        txfName.addTarget(self, action: #selector(nameDidEndEditing), for: .editingDidEnd)
        txfPhone.addTarget(self, action: #selector(phoneDidEndEditing), for: .editingDidEnd)
        txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidEndEditing), for: .editingDidEnd)
        txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidEndEditing), for: .editingDidEnd)
        txfEmail.addTarget(self, action: #selector(emailDidEndEditing), for: .editingDidEnd)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = babyID {
                    print("ID recibido: \(id)")
        }
    }
    
    @objc func nameDidBeginEditing() {
        hasStartedTypingName = true
        lblNameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func phoneDidBeginEditing() {
        hasStartedTypingBirthdate = true
        lblPhoneError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func emailDidBeginEditing() {
        hasStartedTypingBirthdate = true
        lblEmailError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func motherSurnameDidBeginEditing() {
        hasStartedTypingMother = true
        lblMotherError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func fatherSurnameDidBeginEditing() {
        hasStartedTypingFather = true
        lblFatherError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func nameDidChange() {
        textFieldDidChange()
    }
    
    @objc func phoneDidChange() {
        textFieldDidChange()
    }
    
    @objc func emailDidChange() {
        textFieldDidChange()
    }
    
    @objc func motherSurnameDidChange() {
        textFieldDidChange()
    }
    
    @objc func fatherSurnameDidChange() {
        textFieldDidChange()
    }
    
    @objc func nameDidEndEditing() {
        lblNameError.isHidden = true
    }
    
    @objc func phoneDidEndEditing() {
        lblNameError.isHidden = true
    }
    
    @objc func emailDidEndEditing() {
        lblNameError.isHidden = true
    }
    
    @objc func motherSurnameDidEndEditing() {
        lblMotherError.isHidden = true
    }
    
    @objc func fatherSurnameDidEndEditing() {
        lblFatherError.isHidden = true
    }
    
    @objc func textFieldDidChange() {
            let nameText = txfName.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let phoneText = txfPhone.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let emailText = txfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let motherText = txfMotherSurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let fatherText = txfFatherSurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
            
            var nameIsValid = false
            var phoneIsValid = false
            var emailIsValid = false
            var motherIsValid = false
            var fatherIsValid = false
            
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
            
            if hasStartedTypingBirthdate {
               
                if phoneText.isEmpty {
                    lblPhoneError.text = "Phone is required."
                    lblPhoneError.isHidden = false
                }
                
                else if phoneText.count != 10 {
                    lblPhoneError.text = "Phone must be 10 digits long."
                    lblPhoneError.isHidden = false
                } else {
                    
                    // Aquí podrías agregar validación adicional para el formato de la fecha
                    lblPhoneError.isHidden = true
                    phoneIsValid = true
                }
                
            }
        
            if hasStartedTypingBirthdate {
               
                if emailText.isEmpty {
                    lblEmailError.text = "Email is required."
                    lblEmailError.isHidden = false
                } else if !isValidEmail(emailText) {
                    lblEmailError.text = "The email must be a valid email address."
                    lblEmailError.isHidden = false
                }
                else{
                    // Aquí podrías agregar validación adicional para el formato de la fecha
                    lblEmailError.isHidden = true
                    emailIsValid = true
                }
            }
            
            if hasStartedTypingMother {
                if motherText.isEmpty {
                    lblMotherError.text = "Mother's surname is required."
                    lblMotherError.isHidden = false
                } else {
                    lblMotherError.isHidden = true
                    motherIsValid = true
                }
            }
            
            if hasStartedTypingFather {
                if fatherText.isEmpty {
                    lblFatherError.text = "Father's surname is required."
                    lblFatherError.isHidden = false
                } else {
                    lblFatherError.isHidden = true
                    fatherIsValid = true
                }
            }
            
        btnCreate.isEnabled = nameIsValid && phoneIsValid && emailIsValid && motherIsValid && fatherIsValid
        }
    
    private func createURLRequest(for familiarRequest: FamiliarRequest) throws -> URLRequest {
        
            
            let urlString = relativesEndpoint
            
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let token = AuthManager.shared.loadToken()!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(familiarRequest)
            
            return request
        }
    

    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    @IBAction func crear() {
        view.endEditing(true)
        
                    
                guard let name = txfName.text?.trimmingCharacters(in: .whitespaces),
                      let phone = txfPhone.text?.trimmingCharacters(in: .whitespaces),
                      let email = txfEmail.text?.trimmingCharacters(in: .whitespaces),
                      let motherSurname = txfMotherSurname.text?.trimmingCharacters(in: .whitespaces),
                      let fatherSurname = txfFatherSurname.text?.trimmingCharacters(in: .whitespaces),
                      !name.isEmpty, !phone.isEmpty,
                      !email.isEmpty,!motherSurname.isEmpty, !fatherSurname.isEmpty else {
                    showError(message: "Validation errors, please review the form.")
                    return
                }
                
                showLoadingIndicator()
                
        let familiarRequest = FamiliarRequest(baby_id: babyID,name: name, phone_number: phone, email: email, last_name_2: motherSurname, last_name_1: fatherSurname)
                
        print(familiarRequest)
                do {
                    let request = try createURLRequest(for: familiarRequest)
                    
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
                                // Reset fields
                                self?.txfName.text = ""
                                self?.txfPhone.text = ""
                                self?.txfEmail.text = ""
                                self?.txfMotherSurname.text = ""
                                self?.txfFatherSurname.text = ""
                                self?.lblNameError.isHidden = true
                                self?.lblPhoneError.isHidden = true
                                self?.lblEmailError.isHidden = true
                                self?.lblMotherError.isHidden = true
                                self?.lblFatherError.isHidden = true
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
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                let errors = errorResponse.errors
                
                DispatchQueue.main.async { [weak self] in
                    self?.lblNameError.isHidden = true
                    self?.lblPhoneError.isHidden = true
                    self?.lblEmailError.isHidden = true
                    self?.lblMotherError.isHidden = true
                    self?.lblFatherError.isHidden = true
                    
                    if let nameErrors = errors["name"]?.joined(separator: "\n") {
                        self?.lblNameError.text = nameErrors
                        self?.lblNameError.isHidden = false
                    }
                    
                    if let phoneErrors = errors["phone_number"]?.joined(separator: "\n") {
                        self?.lblPhoneError.text = phoneErrors
                        self?.lblPhoneError.isHidden = false
                    }
                    
                    if let emailErrors = errors["email"]?.joined(separator: "\n") {
                        self?.lblEmailError.text = emailErrors
                        self?.lblEmailError.isHidden = false
                    }
                    
                    if let motherErrors = errors["last_name_2"]?.joined(separator: "\n") {
                        self?.lblMotherError.text = motherErrors
                        self?.lblMotherError.isHidden = false
                    }
                    
                    if let fatherErrors = errors["last_name_1"]?.joined(separator: "\n") {
                        self?.lblFatherError.text = fatherErrors
                        self?.lblFatherError.isHidden = false
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
        
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")

            
            do {
                let babyResponse = try JSONDecoder().decode(BabyResponse.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(
                        title: "Success",
                        message: babyResponse.message,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
                
            } catch {
                showError(message: "Error processing the response.")
            }
    }
    
    private func showLoadingIndicator() {
            DispatchQueue.main.async {
                self.btnCreate.configuration?.showsActivityIndicator = true
                self.btnCreate.isEnabled = false
            }
    }
    
    private func showError(message: String) {
            DispatchQueue.main.async {
                self.lblNameError.isHidden = true
                self.lblPhoneError.isHidden = true
                self.lblEmailError.isHidden = true
                self.lblMotherError.isHidden = true
                self.lblFatherError.isHidden = true
                
                let alert = UIAlertController(
                    title: "Error",
                    message: message,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
    }
    
    private func hideLoadingIndicator() {
            DispatchQueue.main.async {
                self.btnCreate.configuration?.showsActivityIndicator = false
                self.btnCreate.isEnabled = true
            }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
}

struct FamiliarRequest: Encodable {
    let baby_id: Int?
    let name: String
    let phone_number: String
    let email: String
    let last_name_2: String
    let last_name_1: String
}
