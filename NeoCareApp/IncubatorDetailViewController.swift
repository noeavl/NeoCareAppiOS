//
//  IncubatorDetailViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 27/02/25.
//

import UIKit

class IncubatorDetailViewController: UIViewController {
    var selectedIncubator:Incubator?
    var selectedRoom:Room?

    @IBOutlet weak var btnDetachment: UIButton!
    @IBOutlet weak var viewBackgroundStatus: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var viewDetachment: UIView!
    @IBOutlet weak var viewSensors: UIView!
    @IBOutlet weak var lblNurse: UILabel!
    @IBOutlet weak var lblBaby: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var backgroundBabyView: UIView!
    @IBOutlet weak var iconBabyView: UIView!
    @IBOutlet weak var labelbabyeView: UIView!
    
    @IBOutlet weak var backgroundNurseView: UIView!
    @IBOutlet weak var iconNurseView: UIView!
    @IBOutlet weak var labelNurseView: UIView!

    @IBOutlet weak var dataButtonView: UIView!
    @IBOutlet weak var incubatorButtonView: UIView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var backgroundDateView: UIView!
    
    let incubatorsEndPoint = "http://34.215.209.108/api/v1/incubators"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let incubator = selectedIncubator {
            if incubator.state == "available" {
                lblNurse.text = "No Nurse"
                lblBaby.text = "No Baby"
            }else{
                lblNurse.text = incubator.nurse
                lblBaby.text = incubator.baby
            }
            lblDate.text = incubator.created_at
            lblId.text = String(incubator.id)
            switch incubator.state.lowercased() {
            case "active":
                viewStatus.backgroundColor = UIColor(named: "rojoBonito")
            case "available":
                viewStatus.backgroundColor = UIColor(named: "verdeBonito")
                btnDetachment.isEnabled = false
                viewDetachment.backgroundColor = .gray
            default:
                viewStatus.backgroundColor = .gray
            }
            lblState.text = incubator.state
        }
        viewBackgroundStatus.layoutIfNeeded()
        viewBackgroundStatus.roundCorners([.allCorners], 100.0)
        viewStatus.layoutIfNeeded()
        viewStatus.roundCorners([.allCorners], 100.0)
        idView.layoutIfNeeded()
        idView.roundCorners([.topLeft, .bottomLeft], 25.0)
        dateView.layoutIfNeeded()
        dateView.roundCorners([.topRight,.bottomRight], 25.0)
        backgroundDateView.layoutIfNeeded()
        backgroundDateView.roundCorners([.allCorners], 100.0)
        labelbabyeView.layoutIfNeeded()
        labelbabyeView.roundCorners([.topRight,.bottomRight], 25.0)
        iconBabyView.layoutIfNeeded()
        iconBabyView.roundCorners([.topLeft,.bottomLeft], 25.0)
        backgroundBabyView.layoutIfNeeded()
        backgroundBabyView.roundCorners([.allCorners], 100.0)
        iconNurseView.layoutIfNeeded()
        iconNurseView.roundCorners([.topLeft,.bottomLeft], 25.0)
        labelNurseView.layoutIfNeeded()
        labelNurseView.roundCorners([.topRight, .bottomRight], 25.0)
        backgroundNurseView.layoutIfNeeded()
        backgroundNurseView.roundCorners([.allCorners], 100.0)
        viewDetachment.layoutIfNeeded()
        viewDetachment.roundCorners([.allCorners], 100.0)
        viewSensors.layoutIfNeeded()
        viewSensors.roundCorners([.allCorners], 100.0)
        
    }
    
    @IBAction func backButton() {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgIncubatorDetailSensor",
           let destinationVC = segue.destination as? SensorsViewController {
            destinationVC.selectedIncubator = selectedIncubator
        }
    }
    
    @IBAction func detachment() {
        let alert = UIAlertController(
                title: "Confirmation",
                message: "Are you sure you want to detach the baby from the incubator?",
                preferredStyle: .alert
            )

            let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.view.endEditing(true)
                guard let room = self.selectedRoom else {
                    self.showError(message: "Validation errors, please review the form.")
                        return
                    }
                
                let incubatorUpdateRequest = IncubatorUpdateRequest(room_id: room.id, state: "available")
                
                do {
                    let request = try self.createURLRequest(for: incubatorUpdateRequest)
                    
                    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    
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
                            case 200:
                                self?.view.endEditing(true)
                                self?.handleSuccessResponse(data: data)
                            case 422:
                                self?.showError(message: "Validation errors.")
                            default:
                                self?.showError(message: "Unknown Error.")
                            }
                            print(httpResponse)
                        }
                    }.resume()
                } catch {
                    self.showError(message: "Error creating the request.")
                }
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            alert.addAction(okAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
    }
    
    private func createURLRequest(for incubatorUpdateRequest: IncubatorUpdateRequest) throws -> URLRequest {
        guard let selectedIncubator = selectedIncubator else {
                throw NetworkError.invalidParameters
            }

        guard let url = URL(string: "\(incubatorsEndPoint)/\(selectedIncubator.id)") else {
                throw NetworkError.invalidURL
            }
        let token = AuthManager.shared.loadToken()!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(incubatorUpdateRequest)
        
        return request
    }
    
    private func handleSuccessResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let incubatorUpdateResponse = try JSONDecoder().decode(IncubatorUpdateResponse.self, from: data)
            let alert = UIAlertController(
                title: "Success",
                message: incubatorUpdateResponse.msg,
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

struct IncubatorUpdateRequest: Encodable {
    let room_id: Int
    let state: String
}

struct IncubatorUpdateResponse: Decodable {
    let msg: String
}
