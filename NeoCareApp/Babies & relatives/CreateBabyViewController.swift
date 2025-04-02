//
//  CreateBabyViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit



class CreateBabyViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var lblBirthdateError: UILabel!
    
    @IBOutlet weak var lblNameError: UILabel!
    
    @IBOutlet weak var lblFatherError: UILabel!
    
    @IBOutlet weak var lblMotherError: UILabel!
    
   
    @IBOutlet weak var txfBirthDate: UITextField!
    
    @IBOutlet weak var txfMotherSurname: UITextField!
    
    @IBOutlet weak var txfFatherSurname: UITextField!
    
    @IBOutlet weak var txfName: UITextField!
    
    @IBOutlet weak var btnCreate: UIButton!
    
    var hasStartedTypingName = false
       var hasStartedTypingBirthdate = false
       var hasStartedTypingMother = false
       var hasStartedTypingFather = false
       
       let babiesEndpoint = "http://34.215.209.108/api/v1/babies"
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            //txfBirthDate.delegate = self
            // Si es necesario, asigna también el delegate a otros textfields
        
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
            txfBirthDate.inputView = datePicker
            
            let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissDatePicker))
                toolbar.setItems([doneButton], animated: false)
                txfBirthDate.inputAccessoryView = toolbar
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
            
            btnCreate.isEnabled = false
            lblNameError.isHidden = true
            lblBirthdateError.isHidden = true
            lblMotherError.isHidden = true
            lblFatherError.isHidden = true
            
            txfName.setPlaceholderColor(.violeta)
            txfBirthDate.setPlaceholderColor(.violeta)
            txfMotherSurname.setPlaceholderColor(.violeta)
            txfFatherSurname.setPlaceholderColor(.violeta)
            
            txfName.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
            txfBirthDate.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
            txfMotherSurname.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
            txfFatherSurname.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
            
            txfName.addTarget(self, action: #selector(nameDidBeginEditing), for: .editingDidBegin)
            txfBirthDate.addTarget(self, action: #selector(birthdateDidBeginEditing), for: .editingDidBegin)
            txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidBeginEditing), for: .editingDidBegin)
            txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidBeginEditing), for: .editingDidBegin)
            
            txfName.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
            txfBirthDate.addTarget(self, action: #selector(birthdateDidChange), for: .editingChanged)
            txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidChange), for: .editingChanged)
            txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidChange), for: .editingChanged)
            
            txfName.addTarget(self, action: #selector(nameDidEndEditing), for: .editingDidEnd)
            txfBirthDate.addTarget(self, action: #selector(birthdateDidEndEditing), for: .editingDidEnd)
            txfMotherSurname.addTarget(self, action: #selector(motherSurnameDidEndEditing), for: .editingDidEnd)
            txfFatherSurname.addTarget(self, action: #selector(fatherSurnameDidEndEditing), for: .editingDidEnd)
        }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        if let datePicker = txfBirthDate.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd"
               txfBirthDate.text = dateFormatter.string(from: sender.date)
           }
           
           textFieldDidChange()
           txfBirthDate.resignFirstResponder() 
    }
    
    @objc func dismissDatePicker() {
        view.endEditing(true)
    }
 

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func nameDidBeginEditing() {
        hasStartedTypingName = true
        lblNameError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func birthdateDidBeginEditing() {
        hasStartedTypingBirthdate = true
        lblBirthdateError.isHidden = true
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
    
    @objc func birthdateDidChange() {
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
    
    @objc func birthdateDidEndEditing() {
        lblBirthdateError.isHidden = true
    }
    
    @objc func motherSurnameDidEndEditing() {
        lblMotherError.isHidden = true
    }
    
    @objc func fatherSurnameDidEndEditing() {
        lblFatherError.isHidden = true
    }
    
    @objc func textFieldDidChange() {
            let nameText = txfName.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let birthdateText = txfBirthDate.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let motherText = txfMotherSurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
            let fatherText = txfFatherSurname.text?.trimmingCharacters(in: .whitespaces) ?? ""
            
            var nameIsValid = false
            var birthdateIsValid = false
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
               
                if birthdateText.isEmpty {
                    lblBirthdateError.text = "Birthdate is required."
                    lblBirthdateError.isHidden = false
                }
                else{
                    // Aquí podrías agregar validación adicional para el formato de la fecha
                    lblBirthdateError.isHidden = true
                    birthdateIsValid = true
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
            
            btnCreate.isEnabled = nameIsValid && birthdateIsValid && motherIsValid && fatherIsValid
        }
    
    private func createURLRequest(for babyRequest: BabyRequest) throws -> URLRequest {
            guard let hospitalId = AuthManager.shared.getHospitalId() else {
                self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
            
            let urlString = babiesEndpoint // + "?hospital_id=\(hospitalId)"
            
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let token = AuthManager.shared.loadToken()!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(babyRequest)
            
            return request
        }
    

    @IBAction func Regresar() {
        dismiss(animated: true)
    }
   
    @IBAction func crear() {
        view.endEditing(true)
        
                    guard let hospitalId = AuthManager.shared.getHospitalId() else {
                        self.showError(message: "No hospital found.")
                        return
                    }
                guard let name = txfName.text?.trimmingCharacters(in: .whitespaces),
                      let birthdate = txfBirthDate.text?.trimmingCharacters(in: .whitespaces),
                      let motherSurname = txfMotherSurname.text?.trimmingCharacters(in: .whitespaces),
                      let fatherSurname = txfFatherSurname.text?.trimmingCharacters(in: .whitespaces),
                      !name.isEmpty, !birthdate.isEmpty, !motherSurname.isEmpty, !fatherSurname.isEmpty else {
                    showError(message: "Validation errors, please review the form.")
                    return
                }
                
                showLoadingIndicator()
                
        let babyRequest = BabyRequest(hospital_id: hospitalId,name: name, date_of_birth: birthdate, last_name_2: motherSurname, last_name_1: fatherSurname)
                
        print(babyRequest)
                do {
                    let request = try createURLRequest(for: babyRequest)
                    
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
                                self?.txfBirthDate.text = ""
                                self?.txfMotherSurname.text = ""
                                self?.txfFatherSurname.text = ""
                                self?.lblNameError.isHidden = true
                                self?.lblBirthdateError.isHidden = true
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
                    self?.lblBirthdateError.isHidden = true
                    self?.lblMotherError.isHidden = true
                    self?.lblFatherError.isHidden = true
                    
                    if let nameErrors = errors["name"]?.joined(separator: "\n") {
                        self?.lblNameError.text = nameErrors
                        self?.lblNameError.isHidden = false
                    }
                    
                    if let birthdateErrors = errors["date_of_birth"]?.joined(separator: "\n") {
                        self?.lblBirthdateError.text = birthdateErrors
                        self?.lblBirthdateError.isHidden = false
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
                self.lblBirthdateError.isHidden = true
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
    
}

struct BabyRequest: Encodable {
    let hospital_id: Int
    let name: String
    let date_of_birth: String
    let last_name_2: String
    let last_name_1: String
}

struct BabyResponse: Decodable {
    let message: String
}

