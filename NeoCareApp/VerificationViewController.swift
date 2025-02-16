//
//  VerificationViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 15/02/25.
//

import UIKit

class VerificationViewController: UIViewController {

    @IBOutlet weak var txfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txfEmail.setPlaceholderColor(.violeta)
        txfEmail.applyStyle(cornerRadius: 25, borderWidth: 1.0, borderColor: .violeta)
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
