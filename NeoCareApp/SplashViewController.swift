//
//  SplashViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 25/03/25.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AuthManager.shared.loadToken() != nil{
            DispatchQueue.main.async { [weak self] in
                self?.performSegue(withIdentifier: "sgSplashHome", sender: self)
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { tiempo in
            self.performSegue(withIdentifier: "sgSplash", sender: nil)
        }
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
