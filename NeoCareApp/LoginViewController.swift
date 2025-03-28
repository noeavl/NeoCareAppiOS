//
//  LoginViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 12/02/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    
    var hasStartedTypingEmail = false
    var hasStartedTypingPassword = false
    
    let loginEndpoint = "http://34.215.209.108/api/v1/sessions/login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Cerrar el teclado cuando toca la vista de la pantalla.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        lblEmailError.isHidden = true
        lblPasswordError.isHidden = true
        
        // Estilos para los campos de texto.
        txfEmail.setPlaceholderColor(.violeta)
        txfPassword.setPlaceholderColor(.violeta)
        txfEmail.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfPassword.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        
        // Configuracion inicial del boton.
        btnLogin.isEnabled = false
        
        // Observadores para cambios en los campos.
        txfEmail.addTarget(self, action: #selector(emailDidBeginEditing), for: .editingDidBegin)
        txfPassword.addTarget(self, action: #selector(passwordDidBeginEditing), for: .editingDidBegin)
        txfEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txfPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txfEmail.addTarget(self, action: #selector(emailDidEndEditing), for: .editingDidEnd)
        txfPassword.addTarget(self, action: #selector(passwordDidEndEditing), for: .editingDidEnd)
    }
    
    @IBAction func login() {
        view.endEditing(true)
        
        guard let email = txfEmail.text?.trimmingCharacters(in: .whitespaces),let password = txfPassword.text?.trimmingCharacters(in: .whitespaces),
                  !email.isEmpty, !password.isEmpty else {
                showError(message: "Please enter both email and password")
                return
            }
        
        showLoadingIndicator()
        
        let loginRequest = LoginRequest(email: email, password: password)
        do {
            let request = try createURLRequest(for: loginRequest)
            
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
                        self?.handleSuccessResponse(data: data)
                    case 401:
                        self?.handleWarningResponse(data: data)
                    case 422:
                        if let data = data {
                                self?.handleValidationErrors(data: data)
                            } else {
                                self?.showError(message: "Validation errors, please review the form.")
                            }
                    default:
                        self?.showError(message: "Unknown Error.")
                    }
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
                self?.lblEmailError.isHidden = true
                self?.lblPasswordError.isHidden = true
                
                // Mostrar errores por campo
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
    
    // Función para crear la estructura de la solicitud.
    private func createURLRequest(for loginRequest: LoginRequest) throws -> URLRequest {
        guard let url = URL(string: loginEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(loginRequest)
        
        return request
    }
    private func handleSuccessResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            AuthManager.shared.saveAuthData(
                token: loginResponse.token ?? "",
                role: loginResponse.role ?? "",
                hospitalId: loginResponse.hospital_id ?? 1
            )
            self.navigateToHomeScreen()
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func handleWarningResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            let alert = UIAlertController(
                title: "Unauthorized",
                message: loginResponse.message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            
            self.lblEmailError.isHidden = true
            self.lblPasswordError.isHidden = true
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @objc func textFieldDidChange() {
        
        let emailText = txfEmail.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let passwordText = txfPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var emailIsValid = false
        var passwordIsValid = false
        
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
            } else {
                lblPasswordError.isHidden = true
                passwordIsValid = true
            }
        }
        
        btnLogin.isEnabled = emailIsValid && passwordIsValid
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func emailDidEndEditing() {
        // Limpiar error cuando pierde el foco
        lblEmailError.isHidden = true
    }

    @objc func passwordDidEndEditing() {
        // Limpiar error cuando pierde el foco
        lblPasswordError.isHidden = true
    }

    // Funcion para mostrar una animacion de carga en el boton.
    private func showLoadingIndicator() {
        btnLogin.configuration?.showsActivityIndicator = true
        btnLogin.isEnabled = false
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.btnLogin.configuration?.showsActivityIndicator = false
            self.btnLogin.isEnabled = true
        }
    }
    
    private func navigateToHomeScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "sgLoginHome", sender: self)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let message: String
    let token: String?
    let role: String?
    let hospital_id: Int?
}

enum NetworkError: Error {
    case invalidURL
    case encodingError
    case decodingError
}
