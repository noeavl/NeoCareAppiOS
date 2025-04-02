//
//  BabyDetailsViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class BabyDetailsViewController: UIViewController, UITableViewDataSource {
    
    var selectedBaby: Baby?
    var relatives: [Familiar] = []
    let relativesEndPoint = "http://34.215.209.108/api/v1/relativesNoPaginate"
    
    @IBOutlet weak var lblBirthDate: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var viewAddIncubator: UIView!
    
    @IBOutlet weak var viewAddFamiliar: UIView!
    
    @IBOutlet weak var tableViewRelatives: UITableView!
    
    @IBOutlet weak var viewBgInfo: UIView!
    @IBOutlet weak var viewInfo: UIView!
    //inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupActivityIndicator()
        tableViewRelatives.dataSource = self
        
        viewAddIncubator.roundCorners([.allCorners], 30.0)
        viewAddFamiliar.roundCorners([.allCorners], 30.0)
        viewInfo.roundCorners([.allCorners], 30.0)
        viewBgInfo.roundCorners([.allCorners], 30.0)
        
        getRelatives()
        

                    
    }
    
    public func setup(){
        if let baby = selectedBaby {
            lblNombre.text = baby.full_name
            lblBirthDate.text = baby.date_of_birth
        } else{
            print("selectedBaby es nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgCreateFamiliar" {
            if let destinationVC = segue.destination as? AddFamiliarViewController {
                destinationVC.babyID = selectedBaby?.id as? Int
            }
        }
    }
    
    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private func createURLRequest() throws -> URLRequest {
        guard let babyId = selectedBaby?.id else {
                throw NetworkError.invalidURL
            }
            
            let urlString = "\(relativesEndPoint)/\(babyId)"
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            let token = AuthManager.shared.loadToken() ?? ""
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
            return request
    }
    
    private func getRelatives() {
        activityIndicator.startAnimating()
        do {
            let request = try createURLRequest()
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                
                if let error = error {
                    self?.showError(message: "Error de red: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showError(message: "Respuesta inválida del servidor")
                    return
                }
                
                // Depuración: Imprime el código de estado y los datos
                print("Status Code:", httpResponse.statusCode)
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response Data:", jsonString)
                }
                
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 200...299:
                        self?.handleSuccessResponse(data: data)
                    case 400:
                        self?.showError(message: "Solicitud incorrecta")
                    case 401:
                        self?.showError(message: "No autorizado - token inválido")
                    case 404:
                        self?.showError(message: "No se encontraron familiares para este bebé")
                    case 500:
                        self?.showError(message: "Error interno del servidor")
                    default:
                        self?.showError(message: "Error desconocido - Código: \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        } catch {
            activityIndicator.stopAnimating()
            showError(message: "Error creando la solicitud: \(error.localizedDescription)")
        }
    }
    
    
    private func handleSuccessResponse(data: Data?) {
        DispatchQueue.main.async {
                   self.activityIndicator.stopAnimating()
                    self.tableViewRelatives.reloadData()
               }
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let relativesResponse = try JSONDecoder().decode(RelativesResponse.self, from: data)
            relatives = relativesResponse.data
            DispatchQueue.main.async {
                self.tableViewRelatives.reloadData()
            }
            
            if self.relatives.isEmpty {
                self.showNoRelativesMessage()
            } else {
                self.hideNoRelativesMessage()
            }
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                    showError(message: "Error decoding JSON: \(error.localizedDescription)\nJSON: \(jsonString)")
                } else {
                    showError(message: "Error decoding JSON: \(error.localizedDescription)")
                }
        }
    }
    
    private func showNoRelativesMessage() {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "No babies available"
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            label.numberOfLines = 0
            return label
        }()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewRelatives.bounds.width, height: 100))
        messageLabel.frame = containerView.bounds
        containerView.addSubview(messageLabel)
        
        tableViewRelatives.backgroundView = containerView
    }
    
    private func hideNoRelativesMessage() {
        tableViewRelatives.backgroundView = nil
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
        return relatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamiliarCell", for: indexPath)as! FamiliarTableViewCell
        let familiar = relatives[indexPath.row]
        cell.lblName.text = familiar.full_name
        cell.lblPhone.text = familiar.phone_number
        cell.lblEmail.text = familiar.email
        return cell
    }
    
    
}

struct RelativesResponse:Decodable {
    let data: [Familiar]
}
struct Familiar:Decodable{
    let full_name: String
    let phone_number:String
    let email:String

}


