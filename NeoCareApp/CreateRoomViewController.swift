//
//  CreateRoomViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 16/02/25.
//

import UIKit

class CreateRoomViewController: UIViewController {

    @IBOutlet weak var txfName: UITextField!
    @IBOutlet weak var txfRoomNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txfName.setPlaceholderColor(.violeta)
        txfRoomNumber.setPlaceholderColor(.violeta)
        txfName.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfRoomNumber.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
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
