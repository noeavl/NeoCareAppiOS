//
//  RoomsViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class RoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableViewRooms: UITableView!
    let roomsEndPoint = ""
    
    struct Room{
        let number: Int
        let name: String
    }
    
    var rooms: [Room] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRooms.dataSource = self
        tableViewRooms.delegate = self
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
        
        let selectedRoom = rooms[indexPath.row]
        
        let detailViewController = RoomDetailViewController()
        
        detailViewController.room = selectedRoom
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
