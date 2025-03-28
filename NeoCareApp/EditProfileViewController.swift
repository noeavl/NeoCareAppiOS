//
//  EditProfileViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 27/03/25.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txfRFC: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfSecondSurname: UITextField!
    @IBOutlet weak var txfFirstSurname: UITextField!
    @IBOutlet weak var txfName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func back() {
        dismiss(animated: true)
    }
    @IBAction func update() {
    }
}
