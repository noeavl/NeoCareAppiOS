//
//  BabyDetailsViewController.swift
//  NeoCareApp
//
//  Created by Jonathan Talavera on 18/02/25.
//

import UIKit

class BabyDetailsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var viewAddIncubator: UIView!
    
    @IBOutlet weak var viewAddFamiliar: UIView!
    
    @IBOutlet weak var tableViewRelatives: UITableView!
    
    //inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRelatives.dataSource = self
        viewAddIncubator.roundCorners([.allCorners], 40.0)
        viewAddFamiliar.roundCorners([.allCorners], 40.0)
    }
    
    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    // table view
    struct familiar{
        let id: Int
        let name:String
        let phone:String
        let email:String
    
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamiliarCell", for: indexPath)as! FamiliarTableViewCell
        let familiar = relatives[indexPath.row]
        cell.lblName.text = familiar.name
        cell.lblPhone.text = familiar.phone
        cell.lblEmail.text = familiar.email
        return cell
    }
    
    var relatives: [familiar] = [
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
        familiar(id: 1, name: "jona", phone: "8715066383", email: "jona@gmail.com"),
    ]
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


