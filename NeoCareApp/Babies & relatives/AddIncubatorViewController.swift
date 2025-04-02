//
//  AddIncubatorViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class AddIncubatorViewController: UIViewController {
    
    
    @IBOutlet weak var pkvIncubator: UIPickerView!
    @IBOutlet weak var pkvNurse: UIPickerView!
    
    @IBOutlet weak var lblIncubatorError: UILabel!
    @IBOutlet weak var lblNurseError: UILabel!
    
    
    @IBOutlet weak var btnCreate: UIButton!
    
    
    var incubators: [IncubatorsResponse] = []
    var nurses: [NursesResponse] = []
    
    let incubatorsEndPoint = "http://34.215.209.108/api/v1/incubators-hospital"
    let nursesEndPoint = "http://34.215.209.108/api/v1/nurses-hospital"
    
    var babyID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pkvIncubator.dataSource = self
               pkvIncubator.delegate = self
               pkvNurse.dataSource = self
               pkvNurse.delegate = self
        
        lblNurseError.isHidden = true
        lblIncubatorError.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
                   self.showError(message: "No hospital found.")
                   return
        }
        
        if let id = babyID {
                    print("ID recibido: \(id)")
        }
        
        fetchIncubators(hospitalId: hospitalId)
        fetchNurses(hospitalId: hospitalId)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func crear(_ sender: UIButton){
        assignBabyToIncubator()
    }
    
    private func createURLRequest(for urlString: String) throws -> URLRequest {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let token = AuthManager.shared.loadToken()!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            
            return request
    }
    
    func fetchIncubators(hospitalId: Int) {
            // Armar la URL con el hospitalId
            let urlString = "\(incubatorsEndPoint)/\(hospitalId)"
            do {
                    let request = try createURLRequest(for: urlString)
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            DispatchQueue.main.async {
                                self.lblIncubatorError.text = "Error: \(error.localizedDescription)"
                                self.lblIncubatorError
                                    .isHidden = false
                            }
                            return
                        }
                        guard let data = data else { return }
                        
                        
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Respuesta JSON de incubators: \(jsonString)")
                        }
                        
                        do {
                            let wrapper = try JSONDecoder().decode(IncubatorsWrapper.self, from: data)
                            self.incubators = wrapper.data
                            DispatchQueue.main.async {
                                self.pkvIncubator.reloadAllComponents()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.lblIncubatorError.text = "No incubators were found available"
                                self.lblIncubatorError.isHidden = false
                            }
                        }
                    }.resume()
                } catch {
                    self.lblIncubatorError.text = "Error: \(error.localizedDescription)"
                    self.lblIncubatorError.isHidden = false
                }
        }
    
        
        func fetchNurses(hospitalId: Int) {
            let urlString = "\(nursesEndPoint)/\(hospitalId)"
                do {
                        let request = try createURLRequest(for: urlString)
                        
                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if let error = error {
                                DispatchQueue.main.async {
                                    self.lblNurseError.text = "Error: \(error.localizedDescription)"
                                    self.lblNurseError.isHidden = false
                                }
                                return
                            }
                            guard let data = data else { return }
                            
                            /* if let jsonString = String(data: data, encoding: .utf8) {
                                print("Respuesta JSON de nurses: \(jsonString)")
                            } */
                            
                            do {
                                let wrapper = try JSONDecoder().decode(NursesWrapper.self, from: data)
                                self.nurses = wrapper.data
                                DispatchQueue.main.async {
                                    self.pkvNurse.reloadAllComponents()
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    self.lblNurseError.text = "No nurses were found"
                                    self.lblNurseError.isHidden = false
                                }
                            }
                        }.resume()
                    } catch {
                        self.lblNurseError.text = "Error: \(error.localizedDescription)"
                        self.lblNurseError.isHidden = false
                    }
    }
        
   
    private func showError(message: String) {
            DispatchQueue.main.async {
                self.lblIncubatorError.isHidden = true
                self.lblNurseError.isHidden = true
                
                let alert = UIAlertController(
                    title: "Error",
                    message: message,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
    }

}

struct IncubatorsWrapper: Decodable {
    let data: [IncubatorsResponse]
}

struct NursesWrapper: Decodable {
    let data: [NursesResponse]
}

struct IncubatorsResponse: Decodable
{
    let id: Int
}

struct NursesResponse: Decodable
{
    let id: Int
    let full_name: String
    let hospital_id: Int
}

struct AddRequest: Encodable
{
    let baby_id: Int
    let incubator_id: Int
    let nurse_id: Int
}

struct AddResponse: Decodable
{
    let message: String
}

extension AddIncubatorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pkvIncubator {
            return incubators.count
        } else if pickerView == pkvNurse {
            return nurses.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pkvIncubator {
                let incubator = incubators[row]
                return "Incubator \(incubator.id)"
        } else if pickerView == pkvNurse {
            let nurse = nurses[row]
            return nurse.full_name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pkvIncubator {
            let selectedIncubatorId = incubators[row].id
            print("Incubator seleccionado: \(selectedIncubatorId)")
        } else if pickerView == pkvNurse {
            let selectedNurseId = nurses[row].id
            print("Nurse seleccionado: \(selectedNurseId)")
        }
    }
}

extension AddIncubatorViewController {
    
    func assignBabyToIncubator() {
        
        guard let babyID = babyID else {
            self.showError(message: "Baby ID no disponible.")
            return
        }
        
        let selectedIncubatorRow = pkvIncubator.selectedRow(inComponent: 0)
        let selectedNurseRow = pkvNurse.selectedRow(inComponent: 0)
        
       
        guard incubators.indices.contains(selectedIncubatorRow),
              nurses.indices.contains(selectedNurseRow) else {
            self.showError(message: "Selecciona un incubator y una nurse.")
            return
        }
        
        let incubatorID = incubators[selectedIncubatorRow].id
        let nurseID = nurses[selectedNurseRow].id
        
        let addRequest = AddRequest(baby_id: babyID, incubator_id: incubatorID, nurse_id: nurseID)
        
        let urlString = "http://34.215.209.108/api/v1/baby-to-incubator"
        
        do {
            var request = try createURLRequest(for: urlString)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(addRequest)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showError(message: "Error en la asignación: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.showError(message: "No se recibieron datos.")
                    }
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Respuesta de asignación: \(jsonString)")
                }
                
              
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }
            }.resume()
        } catch {
            self.showError(message: "Error: \(error.localizedDescription)")
        }
    }
    
    func showSuccessAlert() {
            let alert = UIAlertController(title: "Success", message: "Baby asignado correctamente.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
}

