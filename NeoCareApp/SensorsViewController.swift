//
//  SensorsViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 21/02/25.
//

import UIKit

class SensorsViewController: UIViewController {

    @IBOutlet var backgroundSensors: [UIView]!
    @IBOutlet var backgroundSensorLbl: [UIView]!
    @IBOutlet var backgroundInfoSensor: [UIView]!
    @IBOutlet var backgroundStatus: [UIView]!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for backgroundSensor in backgroundSensors {
            backgroundSensor.layer.cornerRadius = 10
            backgroundSensor.clipsToBounds = true
        }
        
        for backgroundSensorLbl in backgroundSensorLbl {
            backgroundSensorLbl.layer.cornerRadius = 10
            backgroundSensorLbl.clipsToBounds = true
        }
        
        for backgroundInfoSensor in backgroundInfoSensor {
            backgroundInfoSensor.layer.cornerRadius = 10
            backgroundInfoSensor.clipsToBounds = true   
        }
        
        for backgroundStatus in backgroundStatus {
            backgroundStatus.layer.cornerRadius = 10
            backgroundStatus.clipsToBounds = true
        }
    }

    @IBAction func dismissView() {
        dismiss(animated: true)
    }
}
