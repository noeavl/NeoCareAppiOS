//
//  ProfileViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 19/02/25.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imvProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regresar() {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logout() {
        
        let alert = UIAlertController(
                title: "Log Out",
                message: "Are you sure you want to log out of your account?",
                preferredStyle: .alert
            )
            
            // Acción para confirmar el logout
            let confirmAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
                AuthManager.shared.logout()
                self.performSegue(withIdentifier: "sgProfileLogin", sender: nil)
            }
            
            // Acción para cancelar
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
    }
    
}
