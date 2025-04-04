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
    
    let sendEmailEndpoint = "http://34.215.209.108/api/v1/sessions/resend-activation"
    
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
        
        view.endEditing(true)
        
        guard let email = txfEmail.text?.trimmingCharacters(in: .whitespaces) else{
            showError(message: "Please enter both email and password")
            return
        }
        
        showLoadingIndicator()
        
        let sendEmailRequest = SendEmailRequest(email: email, is_app: true)
        
        do{
            let request = try createURLRequest(for: sendEmailRequest)
            URLSession.shared.dataTask(with: request) { [weak self ]data, response, error in
                self?.hideLoadingIndicator()
                
                if let error = error {
                    self?.showError(message: "Error de red:\(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showError(message: "Invalid Response.")
                    return
                }
                
                DispatchQueue.main.sync {
                    switch httpResponse.statusCode {
                    case 200...299:
                        self?.txfEmail.text = ""
                        self?.btnSend.isEnabled = false
                        self?.view.endEditing(true)
                        self?.handleSuccessResponse(data: data)
                    case 422:
                        if let data = data{
                            self?.handleValidationErrors(data: data)
                        }else{
                            self?.showError(message: "Validation errors, please review the form.")
                        }
                    default:
                        self?.showError(message: "Unknown Error.")
                    }
                }
            }.resume()
        }catch{
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
                self?.lblEmailError.isHidden = true
                
                // Mostrar errores por campo
                if let emailErrors = errors["email"]?.joined(separator: "\n") {
                    self?.lblEmailError.text = emailErrors
                    self?.lblEmailError.isHidden = false
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
            let sendEmailResponse = try JSONDecoder().decode(SendEmailResponse.self, from: data)
            let alert = UIAlertController(title: "Success", message: "\(sendEmailResponse.message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.btnSend.configuration?.showsActivityIndicator = false
            self.btnSend.isEnabled = true
        }
    }
    
    private func createURLRequest(for sendEmailRequest: SendEmailRequest) throws -> URLRequest {
        guard let url = URL(string: sendEmailEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(sendEmailRequest)
        
        return request
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            
            self.lblEmailError.isHidden = true
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
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
    
    private func showLoadingIndicator() {
        btnSend.configuration?.showsActivityIndicator = true
        btnSend.isEnabled = false
    }
}

struct SendEmailRequest: Encodable {
    let email: String
    let is_app: Bool
}

struct SendEmailResponse:Decodable{
    let message: String
}


