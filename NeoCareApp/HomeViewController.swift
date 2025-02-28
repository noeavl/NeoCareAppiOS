//
//  HomeViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 26/02/25.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var incubatorTbv: UITableView!
    @IBOutlet weak var welcomeView: UIView!
    
    struct Incubator{
        let babyName: String
        let nurseName: String
    }
    
    var incubators: [Incubator] = [
        Incubator(babyName: "Noé Abel", nurseName: "Jonathan Castro"),
        Incubator(babyName: "Noé Abel", nurseName: "Jonathan Castro"),
        Incubator(babyName: "Noé Abel", nurseName: "Jonathan Castro"),
        Incubator(babyName: "Noé Abel", nurseName: "Jonathan Castro"),
        Incubator(babyName: "Noé Abel", nurseName: "Jonathan Castro")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incubatorTbv.dataSource = self
        incubatorTbv.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        welcomeView.layer.cornerRadius = 10.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incubators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = incubatorTbv.dequeueReusableCell(withIdentifier: "IncubatorCell", for:indexPath)as! IncubatorsTableTableViewCell
        
        let incubator = incubators[indexPath.row]
        cell.babyNameLbl.text = incubator.babyName
        cell.nurseNameLbl.text = incubator.nurseName
        
        return cell
    }
}
