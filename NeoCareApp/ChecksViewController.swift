//
//  ChecksViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class ChecksViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{
    @IBOutlet weak var tableViewChecks: UITableView!
    
    @IBOutlet weak var viewBtnCreate: UIView!
    private let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()
    
    var checks: [Check] = []
    let checksEndPoint = "http://34.215.209.108/api/v1/checksNoPaginate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChecks.dataSource = self
        tableViewChecks.delegate = self
        viewBtnCreate.roundCorners([.allCorners], 100.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupActivityIndicator()
        getChecks()
    }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func createURLRequest() throws -> URLRequest {
        guard let url = URL(string: checksEndPoint ) else {
            throw NetworkError.invalidURL
        }
        
        let token = AuthManager.shared.loadToken() ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getChecks(){
        activityIndicator.startAnimating()
        do{
            let request = try createURLRequest()
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                DispatchQueue.main.async {
                                    self?.activityIndicator.stopAnimating() // Detener en todas las respuestas
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
                   self.tableViewChecks.reloadData()
               }
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let checksResponse = try JSONDecoder().decode(ChecksResponse.self, from: data)
            checks = checksResponse.data
            DispatchQueue.main.async {
                self.tableViewChecks.reloadData()
            }
            
            if self.checks.isEmpty {
                self.showNoChecksMessage()
            } else {
                self.hideNoChecksMessage()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "sgChecksDetail",
           let destinationVC = segue.destination as? CheckDetailViewController,
               let selectedCheck = sender as? Check {
                destinationVC.selectedCheck = selectedCheck
            }
    }
    
    private func showNoChecksMessage() {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "No rooms available"
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.numberOfLines = 0
            return label
        }()
        
        // Crear un contenedor para el mensaje
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewChecks.bounds.width, height: 100))
        messageLabel.frame = containerView.bounds
        containerView.addSubview(messageLabel)
        
        // Establecer como vista de fondo
        tableViewChecks.backgroundView = containerView
    }
    
    private func hideNoChecksMessage() {
        tableViewChecks.backgroundView = nil
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
        return checks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableViewChecks.dequeueReusableCell(withIdentifier: "CheckCell", for:indexPath)as! ChecksTableViewCell
        let check = checks[indexPath.row]
        cell.lblTitle.text = check.title
        cell.lblBaby.text = check.baby
        cell.lblDate.text = check.created_at
        if(check.nurse == nil){
            cell.lblNurse.isHidden = true
            cell.iconNurse.isHidden = true
        }else{
            cell.lblNurse.text = check.nurse
        }
        cell.lblId.text = String(check.check_id)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "sgChecksDetail", sender: checks[indexPath.row])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct ChecksResponse:Decodable {
    let data: [Check]
}

struct Check:Decodable{
    let check_id: Int;
    let title: String;
    let nurse: String!;
    let description: String;
    let baby:String;
    let baby_date_of_birth: String;
    let created_at: String;
}
