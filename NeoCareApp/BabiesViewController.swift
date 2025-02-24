//
//  BabiesViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class BabiesViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return babies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BabyCell", for: indexPath)as!
            BabyTableViewCell
        let baby = babies[indexPath.row]
        cell.lblName.text = baby.name
        cell.lblBirthDate.text = dateFormatter.string(from: baby.birthdate)
        cell.lblIncubator.text =
           String(baby.incubator)
        return cell
    }
    
    
    
    @IBOutlet weak var tableViewBabies: UITableView!
    struct baby{
        let id:Int
        let name:String
        let birthdate:Date
        let incubator:Int
        
    }
    
    private let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewBabies.dataSource = self
        
    }
    
    
    
    var babies: [baby] = [
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1),
        baby(id: 1, name: "Manuel Medrano Castro", birthdate: Date() , incubator: 1)
    ]
    
    
    
}

