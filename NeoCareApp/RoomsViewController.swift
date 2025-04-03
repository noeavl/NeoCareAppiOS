//
//  RoomsViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class RoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var viewBtnCreate: UIView!
    @IBOutlet weak var tableViewRooms: UITableView!
    let roomsEndPoint = "http://34.215.209.108/api/v1/roomsNoPaginate"
    var rooms: [Room] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRooms.dataSource = self
        tableViewRooms.delegate = self
        viewBtnCreate.roundCorners([.allCorners], 100.0)
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
    
    private let activityIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.color = .gray
           indicator.translatesAutoresizingMaskIntoConstraints = false
           return indicator
       }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableViewRooms.dequeueReusableCell(withIdentifier: "RoomCell", for:indexPath)as! RoomsTableViewCell
        let room = rooms[indexPath.row]
        cell.lblRoomNumber.text = String(room.number)
        cell.lblRoomName.text = room.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "sgRoomsDetail", sender: rooms[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgRoomsDetail",
               let destinationVC = segue.destination as? RoomDetailViewController,
               let selectedRoom = sender as? Room {
                destinationVC.selectedRoom = selectedRoom
            }
    }
    
    private func createURLRequest() throws -> URLRequest {
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
            self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
        
        let urlString = roomsEndPoint + "?hospital_id=\(String(hospitalId))"
        
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
    
    private func getRooms(){
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
                   self.tableViewRooms.reloadData()
               }
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let roomsResponse = try JSONDecoder().decode(RoomsResponse.self, from: data)
            rooms = roomsResponse.rooms
            DispatchQueue.main.async {
                self.tableViewRooms.reloadData()
            }
            
            if self.rooms.isEmpty {
                self.showNoRoomsMessage()
            } else {
                self.hideNoRoomsMessage()
            }
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    
    private func showNoRoomsMessage() {
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
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewRooms.bounds.width, height: 100))
        messageLabel.frame = containerView.bounds
        containerView.addSubview(messageLabel)
        
        // Establecer como vista de fondo
        tableViewRooms.backgroundView = containerView
    }
    
    private func hideNoRoomsMessage() {
        tableViewRooms.backgroundView = nil
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
}

struct RoomsResponse: Decodable {
    let rooms: [Room]
}

struct Room: Decodable{
    let id: Int
    let number: Int
    let name: String
    let created_at: String
}
