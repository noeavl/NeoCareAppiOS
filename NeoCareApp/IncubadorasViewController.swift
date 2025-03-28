//
//  IncubadorasViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 21/02/25.
//

import UIKit

class IncubadorasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var incubatorTbv: UITableView!
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incubators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = incubatorTbv.dequeueReusableCell(withIdentifier: "IncubatorCell", for:indexPath) as! IncubatorsTableViewCell
        
        let incubator = incubators[indexPath.row]
        //cell.babyNameLbl.text = incubator.babyName
        //cell.nurseNameLbl!.text = incubator.nurseName
        
        return cell
    }
    @IBAction func regresar() {
        dismiss(animated: true)
    }
}
