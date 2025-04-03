//
//  CreateIncubatorViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 03/04/25.
//

import UIKit

class CreateIncubatorViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pkvRoom: UIPickerView!
    @IBOutlet weak var lblErrorRoom: UILabel!
    @IBOutlet weak var btnCreateIncubator: UIButton!
    
    var rooms: [Room] = []
    var selectedRoom: Room? = nil
    var roomPlaceholder = "Select a Room."
    let roomsEndPoint = "http://34.215.209.108/api/v1/roomsNoPaginate"
    let incubatorsEndPoint = "http://34.215.209.108/api/v1/incubators"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCreateIncubator.isEnabled = false
        pkvRoom.delegate = self
        pkvRoom.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupActivityIndicator()
        getRooms()
    }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func getRooms(){
        activityIndicator.startAnimating()
        do{
            let request = try createURLRequestRooms()
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                DispatchQueue.main.async {
                                    self?.activityIndicator.stopAnimating()
                                }
                
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
                        self?.handleSuccessResponseRooms(data: data)
                    default:
                        
                        self?.showError(message: "Unkown Error")
                    }
                }
            }.resume()
        } catch {
            activityIndicator.stopAnimating()
            showError(message: "Error creating the request.")
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.color = .gray
           indicator.translatesAutoresizingMaskIntoConstraints = false
           return indicator
       }()
    
    @objc func textFieldDidChange() {
        var roomsIsValid = false
        
        if selectedRoom != nil {
            lblErrorRoom.isHidden = true
            roomsIsValid = true
        } else {
            lblErrorRoom.text = "Please select a Room."
            lblErrorRoom.isHidden = false
            roomsIsValid = false
        }
        
        let roomsLoaded = !rooms.isEmpty
        roomsIsValid = roomsLoaded && selectedRoom != nil
        
        btnCreateIncubator.isEnabled = roomsIsValid
    }
    
    @IBAction func createIncubator() {
        view.endEditing(true)
        
        guard let room = selectedRoom else {
                showError(message: "Validation errors, please review the form.")
                return
            }
        
        showLoadingIndicator()
        
        let incubatorRequest = IncubatorRequest(room_id: room.id)
        
        do {
            let request = try createURLRequest(for: incubatorRequest)
            
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
                        self?.lblErrorRoom.isHidden = true
                        self?.btnCreateIncubator.isEnabled = false
                        self?.view.endEditing(true)
                        self?.pkvRoom.selectRow(0, inComponent: 0, animated: true)
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
                    print("EL RESPONSEEE DE CREATE:     ",httpResponse)
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
                self?.lblErrorRoom.isHidden = true
                
                if let roomErrors = errors["room_id"]?.joined(separator: "\n") {
                    self?.lblErrorRoom.text = roomErrors
                    self?.lblErrorRoom.isHidden = false
                }
            }
            
        } catch {
            showError(message: "Validation errors, please review the form.")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rooms.isEmpty ? 1 : rooms.count + 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if rooms.isEmpty{
            return "Loading Rooms..."
        }
        return row == 0 ? roomPlaceholder : String(rooms[row - 1].number)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedRoom = nil
        }else{
            selectedRoom = rooms[row - 1]
        }
        textFieldDidChange()
    }
    
    private func handleSuccessResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let roomResponse = try JSONDecoder().decode(IncubatorResponse.self, from: data)
            let alert = UIAlertController(
                title: "Success",
                message: roomResponse.msg,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func createURLRequestRooms() throws -> URLRequest {
        
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
            self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
        
        let urlString = roomsEndPoint + "?hospital_id=\(String(hospitalId))"
        
        guard let url = URL(string:urlString ) else {
            throw NetworkError.invalidURL
        }
        
        let token = AuthManager.shared.loadToken()!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccessResponseRooms(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let roomsResponse = try JSONDecoder().decode(RoomsResponse.self, from: data)
            rooms = roomsResponse.rooms
            DispatchQueue.main.async {
                self.pkvRoom.reloadAllComponents()
                self.textFieldDidChange()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func createURLRequest(for incubatorRequest: IncubatorRequest) throws -> URLRequest {
        guard let url = URL(string: incubatorsEndPoint) else {
            throw NetworkError.invalidURL
        }
        let token = AuthManager.shared.loadToken()!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(incubatorRequest)
        
        return request
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            
            self.lblErrorRoom.isHidden = true
            
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
            self.btnCreateIncubator.configuration?.showsActivityIndicator = false
            self.btnCreateIncubator.isEnabled = true
        }
    }
    
    private func showLoadingIndicator() {
        btnCreateIncubator.configuration?.showsActivityIndicator = true
        btnCreateIncubator.isEnabled = false
    }
    @IBAction func regresar() {
        dismiss(animated: true)
    }
}
struct IncubatorRequest: Encodable {
    let room_id: Int
}

struct IncubatorResponse : Decodable {
    let msg: String
}
