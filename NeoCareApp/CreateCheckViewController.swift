//
//  CreateCheckViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class CreateCheckViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lblDescriptionError: UILabel!
    @IBOutlet weak var lblBabyIncubatorError: UILabel!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var pkvBabyIncubator: UIPickerView!
    @IBOutlet weak var txfDescription: UITextView!
    @IBOutlet weak var txfTitle: UITextField!
    
    var babyIncubators: [BabyIncubators] = []
    var selectedBabyIncubator: BabyIncubators? = nil
    var babyIncubatorPlaceholder = "Select a BabyIncubator"
    var hasStartedTypingTitle = false
    var hasStartedTypingDescription = false
    
    let babyIncubatorsNoPaginateEndPoint = "http://34.215.209.108/api/v1/babyIncubators"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCreate.isEnabled = false
        pkvBabyIncubator.delegate = self
        pkvBabyIncubator.dataSource = self
        lblBabyIncubatorError.isHidden = true
        lblTitleError.isHidden = true
        lblDescriptionError.isHidden = true
        txfDescription.delegate = self
        
        getBabyIncubators()
        
        txfTitle.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfTitle.setPlaceholderColor(.violeta)
        txfDescription.textColor = UIColor.violeta
        txfDescription.layer.cornerRadius = 25.0
        txfDescription.layer.borderWidth = 1.0
        txfDescription.layer.borderColor = UIColor.violeta.cgColor
        
        txfTitle.addTarget(self, action: #selector(titleDidBeginEditing), for: .editingDidBegin)
        
        txfTitle.addTarget(self, action: #selector(titleDidBeginEditing), for: .editingChanged)
        
        txfTitle.addTarget(self, action: #selector(titleDidEndEditing), for: .editingDidEnd)
    }
    
    @objc func titleDidBeginEditing() {
        hasStartedTypingTitle = true
        lblTitleError.isHidden = true
        textFieldDidChange()
    }
    
    @objc func titleDidEndEditing() {
        lblTitleError.isHidden = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hasStartedTypingDescription = true
        lblDescriptionError.isHidden = true
        textFieldDidChange()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        lblDescriptionError.isHidden = true
    }

    func textViewDidChange(_ textView: UITextView) {
        textFieldDidChange()
    }
    
    
    @objc func textFieldDidChange() {
        let titleText = txfTitle.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let descriptionText = txfDescription.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        var titleIsValid = false
        var descriptionIsValid = false
        var babyIncubatorIsValid = false
        
        if hasStartedTypingTitle {
            if titleText.isEmpty {
                lblTitleError.text = "Title is required."
                lblTitleError.isHidden = false
            } else if titleText.count > 49 {
                lblTitleError.text = "Title must be less than 50 characters."
                lblTitleError.isHidden = false
            } else {
                lblTitleError.isHidden = true
                titleIsValid = true
            }
        }
        
        if hasStartedTypingDescription {
            if descriptionText.isEmpty {
                lblDescriptionError.text = "Description is required."
                lblDescriptionError.isHidden = false
            } else if descriptionText.count > 49 {
                lblDescriptionError.text = "Description must be less than 50 characters."
                lblDescriptionError.isHidden = false
            } else {
                lblDescriptionError.isHidden = true
                descriptionIsValid = true
            }
        }
       
        
        if selectedBabyIncubator != nil {
            lblBabyIncubatorError.isHidden = true
            babyIncubatorIsValid = true
        } else {
            lblBabyIncubatorError.text = "Please select an Incubator"
            lblBabyIncubatorError.isHidden = false
            babyIncubatorIsValid = false
        }
        
        let babyIncubatorsLoaded = !babyIncubators.isEmpty
        babyIncubatorIsValid = babyIncubatorsLoaded && selectedBabyIncubator != nil
        
        btnCreate.isEnabled = titleIsValid && descriptionIsValid && babyIncubatorIsValid
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return babyIncubators.isEmpty ? 1 : babyIncubators.count + 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if babyIncubators.isEmpty{
            return "Loading Incubators..."
        }
        return row == 0 ? babyIncubatorPlaceholder : String(babyIncubators[row - 1].id)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedBabyIncubator = nil
        }else{
            selectedBabyIncubator = babyIncubators[row - 1]
        }
        textFieldDidChange()
    }

    @IBAction func regresar() {
        dismiss(animated: true)
    }
    @IBAction func create() {
    }
    
    private func createURLRequestBabyIncubators() throws -> URLRequest {
        guard let url = URL(string:babyIncubatorsNoPaginateEndPoint ) else {
            throw NetworkError.invalidURL
        }
        
        let token = AuthManager.shared.loadToken()!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccessResponseBabyIncubators(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let babyIncubatorsResponse = try JSONDecoder().decode(BabyIncubatorsResponse.self, from: data)
            babyIncubators = babyIncubatorsResponse.babyIncubators
            DispatchQueue.main.async {
                self.pkvBabyIncubator.reloadAllComponents()
                self.textFieldDidChange()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            
            self.lblBabyIncubatorError.isHidden = true
            self.lblTitleError.isHidden = true
            self.lblDescriptionError.isHidden = true
            
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
    
    private func getBabyIncubators(){
        do{
            let request = try createURLRequestBabyIncubators()
            
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
                        self?.handleSuccessResponseBabyIncubators(data: data)
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

struct BabyIncubators :Decodable {
    let id:Int
    let incubator_id:Int
    let baby_id:Int
    let nurse_id:Int
}

struct BabyIncubatorsResponse: Decodable {
    let babyIncubators: [BabyIncubators]
}
