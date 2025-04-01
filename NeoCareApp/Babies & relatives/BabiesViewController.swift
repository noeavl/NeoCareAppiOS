//
//  BabiesViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class BabiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var tableViewBabies: UITableView!
    
    private let dateFormatter: DateFormatter = {
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd"
               return formatter
           }()
        
        var babies: [Baby] = []
        let babiesEndPoint = "http://34.215.209.108/api/v1/babiesNoPaginate"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupActivityIndicator()
            tableViewBabies.dataSource = self
            tableViewBabies.delegate = self
            viewAdd.roundCorners([.allCorners], 100.0)
            
            getBabies()
        }
        
        private func setupActivityIndicator() {
                view.addSubview(activityIndicator)
                
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        
        private func createURLRequest() throws -> URLRequest {
            guard let url = URL(string: babiesEndPoint ) else {
                throw NetworkError.invalidURL
            }
            
            let token = AuthManager.shared.loadToken() ?? ""
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
            return request
        }
        
        private func getBabies(){
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
                            
                            self?.showError(message: "Unknown Error")
                        }
                    }
                }.resume()
            } catch {
                activityIndicator.stopAnimating()
                showError(message: "Error creating the request.")
            }
        }
        
        private func handleSuccessResponse(data: Data?) {
            DispatchQueue.main.async {
                       self.activityIndicator.stopAnimating()
                       self.tableViewBabies.reloadData()
                   }
            guard let data = data else {
                showError(message: "Empty Response data.")
                return
            }
            
            do {
                let babiesResponse = try JSONDecoder().decode(BabiesResponse.self, from: data)
                babies = babiesResponse.data
                DispatchQueue.main.async {
                    self.tableViewBabies.reloadData()
                }
                
                if self.babies.isEmpty {
                    self.showNoBabiesMessage()
                } else {
                    self.hideNoBabiesMessage()
                }
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                        showError(message: "Error decoding JSON: \(error.localizedDescription)\nJSON: \(jsonString)")
                    } else {
                        showError(message: "Error decoding JSON: \(error.localizedDescription)")
                    }
            }
        }
        
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "sgBabiesDetail",
               let destinationVC = segue.destination as? BabyDetailsViewController {
                
                if let selectedBaby = sender as? Baby {
                    print(" Enviando baby: \(selectedBaby)")
                    destinationVC.selectedBaby = selectedBaby
                } else {
                    print(" El sender no es un Baby o es nil")
                    if let sender = sender {
                        print("Tipo real del sender: \(type(of: sender))")
                    } else {
                        print("Sender es nil")
                    }
                }
            }
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let selectedBaby = babies[indexPath.row]
            print(" Baby seleccionado: \(selectedBaby)")
            print("Tipo del objeto enviado: \(type(of: selectedBaby))") 
            performSegue(withIdentifier: "sgBabiesDetail", sender: selectedBaby)
        }
       
        private func showNoBabiesMessage() {
            let messageLabel: UILabel = {
                let label = UILabel()
                label.text = "No babies available"
                label.textColor = .gray
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                label.numberOfLines = 0
                return label
            }()
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewBabies.bounds.width, height: 100))
            messageLabel.frame = containerView.bounds
            containerView.addSubview(messageLabel)
            
            tableViewBabies.backgroundView = containerView
        }
        
        private func hideNoBabiesMessage() {
            tableViewBabies.backgroundView = nil
        }
        
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
        
        private let activityIndicator: UIActivityIndicatorView = {
               let indicator = UIActivityIndicatorView(style: .large)
               indicator.color = .gray
               indicator.translatesAutoresizingMaskIntoConstraints = false
               return indicator
           }()
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return babies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell  = tableViewBabies.dequeueReusableCell(withIdentifier: "BabyCell", for:indexPath)as! BabyTableViewCell
            let baby = babies[indexPath.row]
            cell.lblName.text = baby.full_name
            cell.lblBirthDate.text = baby.date_of_birth
            cell.lblIncubator.text = baby.incubator_id != nil ? String(baby.incubator_id!) : "sin asignar"

            return cell
        }
    }

    struct BabiesResponse:Decodable {
        let data: [Baby]
    }

    struct Baby:Decodable{
        let id: Int?;
        let date_of_birth: String?;
        let created_at: String?;
        let full_name: String?;
        let incubator_id:Int?;
    }
