//
//  ChecksViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class ChecksViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableViewChecks: UITableView!
    
    struct Check{
        let id: Int;
        let title: String;
        let nurse: String;
        let baby:String;
        let date: Date;
    }
    
    private let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()
    
    var checks: [Check] = [
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()), Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()), Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()), Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date()),
        Check(id: 1, title: "Nacio el bebe", nurse: "Juanita Lopez Perez", baby: "Miguel Pedro Lopez Perez", date: Date())
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChecks.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableViewChecks.dequeueReusableCell(withIdentifier: "CheckCell", for:indexPath)as! ChecksTableViewCell
        let check = checks[indexPath.row]
        cell.lblTitle.text = check.title
        cell.lblBaby.text = check.baby
        cell.lblDate.text = dateFormatter.string(from: check.date)

        return cell
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
