//
//  IncubadorasViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 21/02/25.
//

import UIKit

class IncubadorasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedRoom: Room?
    
    @IBOutlet weak var viewBtnCreate: UIView!
    @IBOutlet weak var incubatorTbv: UITableView!
    
    let incubatorsEndPoint = "http://34.215.209.108/api/v1/incubatorsNoPaginate"
    
    var incubators: [Incubator] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incubatorTbv.dataSource = self
        incubatorTbv.delegate = self
        
        viewBtnCreate.roundCorners([.allCorners], 100.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let role = AuthManager.shared.getRole(), role == "nurse-admin" {
                viewBtnCreate.isHidden = false
            } else {
                viewBtnCreate.isHidden = true
            }

        setupActivityIndicator()
        getIncubators()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incubators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = incubatorTbv.dequeueReusableCell(withIdentifier: "IncubatorCell", for:indexPath) as! IncubatorsTableViewCell
        
        let incubator = incubators[indexPath.row]
       
        cell.lblId.text = String(incubator.id)
        
        switch incubator.state.lowercased() {
        case "active":
            cell.statusView.backgroundColor = UIColor(named: "rojoBonito")
            cell.babyNameLbl.text = incubator.baby
            cell.nurseNameLbl!.text = incubator.nurse!
        case "available":
            cell.statusView.backgroundColor = UIColor(named: "verdeBonito")
            cell.babyNameLbl.text = "No Baby"
            cell.nurseNameLbl!.text = "No Nurse"
        default:
            cell.statusView.backgroundColor = .gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "sgIncubatorDetail", sender: incubators[indexPath.row])
    }
    @IBAction func regresar() {
        dismiss(animated: true)
    }
    @IBAction func create() {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgIncubatorDetail",
               let destinationVC = segue.destination as? IncubatorDetailViewController,
               let selectedIncubator = sender as? Incubator {
            destinationVC.selectedIncubator = selectedIncubator
            destinationVC.selectedRoom = selectedRoom
            }
    }
    private func getIncubators(){
        activityIndicator.startAnimating()
        do{
            let request = try createURLRequest()
            
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
                        self?.handleSuccessResponse(data: data)
                    default:
                        
                        self?.showError(message: "Unkown Error")
                    }
                    print(httpResponse)
                }
            }.resume()
        } catch {
            activityIndicator.stopAnimating()
            showError(message: "Error creating the request.")
        }
    }
    
    private func createURLRequest() throws -> URLRequest {
        guard let room = selectedRoom else {
               throw NetworkError.invalidURL
           }
        
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
            self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
        
        let urlString = "\(incubatorsEndPoint)?room_id=\(room.id)&hospital_id=\(hospitalId)"
        
        guard let url = URL(string: urlString ) else {
            throw NetworkError.invalidURL
        }
        
        let token = AuthManager.shared.loadToken() ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccessResponse(data: Data?) {
        DispatchQueue.main.async {
                   self.activityIndicator.stopAnimating()
                self.incubatorTbv.reloadData()
               }
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let incubatorsListResponse = try JSONDecoder().decode(IncubatorsListResponse.self, from: data)
            incubators = incubatorsListResponse.incubators
            DispatchQueue.main.async {
                self.incubatorTbv.reloadData()
            }
            
            if self.incubators.isEmpty {
                self.showNoIncubatorsMessage()
            } else {
                self.hideNoIncubatorsMessage()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func showNoIncubatorsMessage() {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "No incubators available"
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.numberOfLines = 0
            return label
        }()
        
        // Crear un contenedor para el mensaje
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: incubatorTbv.bounds.width, height: 100))
        messageLabel.frame = containerView.bounds
        containerView.addSubview(messageLabel)
        
        // Establecer como vista de fondo
        incubatorTbv.backgroundView = containerView
    }
    
    private func hideNoIncubatorsMessage() {
        incubatorTbv.backgroundView = nil
    }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private let activityIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.color = .gray
           indicator.translatesAutoresizingMaskIntoConstraints = false
           return indicator
       }()
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
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

struct Incubator: Decodable{
    let id:Int
    let baby: String?
    let nurse: String?
    let created_at: String
    let state: String
}

struct IncubatorsListResponse: Decodable {
    let incubators:[Incubator]
}
