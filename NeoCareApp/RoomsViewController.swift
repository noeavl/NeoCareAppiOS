//
//  RoomsViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class RoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableViewRooms: UITableView!
    let roomsEndPoint = "http://34.215.209.108/api/v1/roomsNoPaginate"
    var rooms: [Room] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRooms.dataSource = self
        tableViewRooms.delegate = self
        
        getRooms()
    }
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
    
    private func createURLRequest() throws -> URLRequest {
        guard let hospitalId = AuthManager.shared.getHospitalId() else {
            self.showError(message: "No hospital found.")
                throw NetworkError.invalidParameters
            }
        
        let urlString = roomsEndPoint + "?hospital_id=\(String(hospitalId))"
        
        print(urlString)
        
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
        do{
            let request = try createURLRequest()
            
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
                    case 200...299:
                        self?.handleSuccessResponse(data: data)
                    default:
                        self?.showError(message: "Unkown Error")
                    }
                }
            }.resume()
        } catch {
            showError(message: "Error creating the request.")
        }
    }
    
    private func handleSuccessResponse(data: Data?) {
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let roomsResponse = try JSONDecoder().decode(RoomsResponse.self, from: data)
            rooms = roomsResponse.rooms
            print(rooms)
            DispatchQueue.main.async {
                self.tableViewRooms.reloadData()
            }
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

struct RoomsResponse: Decodable {
    let rooms: [Room]
}

struct Room: Decodable{
    let number: Int
    let name: String
}
