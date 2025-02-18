//
//  CreateCheckViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 17/02/25.
//

import UIKit

class CreateCheckViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var txfDescription: UITextView!
    @IBOutlet weak var txfTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txfTitle.applyStyle(cornerRadius: 25.0, borderWidth: 1.0, borderColor: .violeta)
        txfTitle.setPlaceholderColor(.violeta)
        txfDescription.textColor = UIColor.violeta
        txfDescription.layer.cornerRadius = 25.0
        txfDescription.layer.borderWidth = 1.0
        txfDescription.layer.borderColor = UIColor.violeta.cgColor
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
