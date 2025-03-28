//
//  CreateRoomViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class CreateRoomViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var lblNameError: UILabel!
    @IBOutlet weak var lblNumberError: UILabel!
    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txfRoomNumber: UITextField!
    var hasStartedTypingName = false
    var hasStartedTypingNumber = false
    let roomsEndpoint = "http://34.215.209.108/api/v1/rooms"
    override func viewDidLoad() {
        super.viewDidLoad()
        txfRoomNumber.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        btnCreate.isEnabled = false
        lblNameError.isHidden = true
        lblNumberError.isHidden = true
       

        txfName.setPlaceholderColor(.violeta)
        txfRoomNumber.setPlaceholderColor(.violeta)
        txfName.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfRoomNumber.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        
        txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingDidBegin)
        txfRoomNumber.addTarget(self, action: #selector(roomNumberDidBeginEditing), for: .editingDidBegin)
        txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingChanged)
        txfRoomNumber.addTarget(self, action: #selector(roomNumberDidBeginEditing), for: .editingChanged)
        txfName.addTarget(self, action: #selector(nameDidEndEditing), for: .editingDidEnd)
        txfRoomNumber.addTarget(self, action: #selector(roomNumberDidEndEditing), for: .editingDidEnd)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == txfRoomNumber {
                // Permite solo números y borrado (backspace)
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
            }
            return true
        }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func nameDidBeginEditing() {
        hasStartedTypingName = true
        lblNameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func roomNumberDidBeginEditing() {
        hasStartedTypingNumber = true
        lblNumberError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func nameDidEndEditing() {
        lblNameError.isHidden = true
    }
    
    @objc func roomNumberDidEndEditing() {
        lblNumberError.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        let nameText = txfName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let numberText = txfRoomNumber.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var nameIsValid = false
        var numberIsValid = false
      
        
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
        
        if hasStartedTypingNumber {
            if numberText.isEmpty {
                lblNumberError.text = "Number is required."
                lblNumberError.isHidden = false
            } else if Int(numberText)! < 1 {
                lblNumberError.text = "Number must be greater than 0."
                lblNumberError.isHidden = false
            } else if numberText.hasPrefix("0") && numberText.count > 1 {
                lblNumberError.text = "Number cannot start with 0."
                lblNumberError.isHidden = false
            } else {
                lblNumberError.isHidden = true
                numberIsValid = true
            }
        }
        
        btnCreate.isEnabled = nameIsValid && numberIsValid
    }
    
    private func createURLRequest(for roomsRequest: RoomRequest) throws -> URLRequest {
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
            self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
        
        let urlString = roomsEndpoint + "?hospital_id=\(String(hospitalId))"
        
        guard let url = URL(string: urlString ) else {
            throw NetworkError.invalidURL
        }

        let token = AuthManager.shared.loadToken()!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(roomsRequest)
        
        return request
    }

    @IBAction func regresar() {
        dismiss(animated: true)
    }
    @IBAction func crear() {
        view.endEditing(true)
        
        guard let name =
                txfName.text?.trimmingCharacters(in: .whitespaces),
              let number =
                txfRoomNumber.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty, !number.isEmpty else {
                showError(message: "Validation errors, please review the form.")
                return
            }
        
        showLoadingIndicator()
        
        let roomRequest = RoomRequest(number: Int(number) ?? -1, name: name)
        
        do {
            let request = try createURLRequest(for: roomRequest)
            
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
                        self?.txfRoomNumber.text = ""
                        self?.lblNameError.isHidden = true
                        self?.lblNumberError.isHidden = true
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
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            let errors = errorResponse.errors
            
            DispatchQueue.main.async { [weak self] in
                // Limpiar errores previos
                self?.lblNameError.isHidden = true
                self?.lblNumberError.isHidden = true
                
                // Mostrar errores por campo
                if let nameErrors = errors["name"]?.joined(separator: "\n") {
                    self?.lblNameError.text = nameErrors
                    self?.lblNameError.isHidden = false
                }
                
                if let numberErrors = errors["number"]?.joined(separator: "\n") {
                    self?.lblNumberError.text = numberErrors
                    self?.lblNumberError.isHidden = false
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
            let roomResponse = try JSONDecoder().decode(RoomResponse.self, from: data)
            let alert = UIAlertController(
                title: "Success",
                message: roomResponse.message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func showLoadingIndicator() {
        btnCreate.configuration?.showsActivityIndicator = true
        btnCreate.isEnabled = false
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            self.lblNameError.isHidden = true
            self.lblNumberError.isHidden = true
            
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
}

struct RoomRequest: Encodable {
    let number: Int
    let name: String
}

struct RoomResponse: Decodable {
    let message: String
}

struct ErrorResponse: Decodable {
    let errors: [String: [String]]
}
