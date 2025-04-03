//
//  SensorsViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 21/02/25.
//

import UIKit

class SensorsViewController: UIViewController {
    var selectedIncubator: Incubator?
    var sensors: [String:Sensor] = [:]

    let sensorsEndPoint = "http://34.215.209.108/api/v1/sensor-data"
    @IBOutlet var backgroundSensors: [UIView]!
    @IBOutlet var backgroundSensorLbl: [UIView]!
    @IBOutlet var backgroundInfoSensor: [UIView]!
    @IBOutlet var backgroundStatus: [UIView]!
    @IBOutlet weak var lblAverageTemperature: UILabel!
    
    @IBOutlet weak var lblAverageSound: UILabel!
    @IBOutlet weak var lblAverageLight: UILabel!
    @IBOutlet weak var lblAverageVibration: UILabel!
    @IBOutlet weak var lblAverageMovement: UILabel!
    @IBOutlet weak var lblAverageHumidity: UILabel!
    @IBOutlet weak var lblAverage: UILabel!
    @IBOutlet weak var lblNoDataVibration: UILabel!
    @IBOutlet weak var lblNoDataLight: UILabel!
    @IBOutlet weak var lblNoDataMovement: UILabel!
    @IBOutlet weak var lblNoDataSound: UILabel!
    @IBOutlet weak var lblNoDataHumidity: UILabel!
    @IBOutlet weak var lblNoDataTemperature: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
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
    override func viewWillAppear(_ animated: Bool) {
        setupActivityIndicator()
        getSensors()
        lblNoDataFound.isHidden = true
    }
    
    private func getSensors(){
        activityIndicator.startAnimating()
        do{
            let request = try createURLRequest()
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                DispatchQueue.main.async {
                                    self?.activityIndicator.stopAnimating()
                                }
                
                if let error = error {
                    self?.showError(message: "Network Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.showError(message: "Invalid Response.")
                    return
                }
                
                DispatchQueue.main.async {
                    switch httpResponse.statusCode {
                    case 200...299:
                        self?.handleSuccessResponse(data: data)
                    case 404:
                        self?.lblNoDataFound.text = "No sensor data found."
                        self?.lblNoDataFound.isHidden = false
                        self?.lblNoDataLight.isHidden = false
                        self?.lblNoDataTemperature.isHidden = false
                        self?.lblNoDataHumidity.isHidden = false
                        self?.lblNoDataSound.isHidden = false
                        self?.lblNoDataMovement.isHidden = false
                        self?.lblNoDataVibration.isHidden = false
                    default:
                        self?.showError(message: "Unkown Error")
                    }
                }
            }.resume()
        } catch {
            activityIndicator.stopAnimating()
            showError(message: "Error creating the request.")
        }
    }
    
    private func createURLRequest() throws -> URLRequest {
        guard let incubator = selectedIncubator else {
               throw NetworkError.invalidURL
           }
        
        let urlString = "\(sensorsEndPoint)/\(incubator.id)"
        
        print(urlString)
        
        guard let url = URL(string: urlString ) else {
            throw NetworkError.invalidURL
        }
        
        let token = AuthManager.shared.loadToken() ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccessResponse(data: Data?) {
        DispatchQueue.main.async {
                   self.activityIndicator.stopAnimating()
               }
        guard let data = data else {
            showError(message: "Empty Response data.")
            return
        }
        
        do {
            let sensorsResponse = try JSONDecoder().decode(SensorsResponse.self, from: data)
            guard let sensorStats = sensorsResponse.sensor_statistics else {
                        showNoDataMessage()
                        return
                    }
            
            // Verificar si todos los sensores están sin datos
            let allSensorsEmpty = sensorStats.values.allSatisfy { !$0.hasData }
            
            if allSensorsEmpty {
                       showNoDataMessage()
                   } else {
                       self.sensors = sensorStats
                       self.lblNoDataFound.isHidden = true
                       self.updateSensorUI()
                   }
                   
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    private func updateSensorUI() {
        // Función helper para formatear valores
        func formatValue(_ value: Float?, unit: String?) -> String {
            guard let value = value, let unit = unit else { return "N/A" }
            return String(format: "%.1f %@", value, unit)
        }
        
        // Temperatura del bebé (TBB)
        if let sensor = sensors["TBB"], sensor.hasData {
            lblAverageTemperature.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataTemperature.isHidden = true
        } else {
            lblAverageTemperature.text = "N/A"
            lblNoDataTemperature.isHidden = false
        }
        
        // Sonido (SON)
        if let sensor = sensors["SON"], sensor.hasData {
            lblAverageSound.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataSound.isHidden = true
        } else {
            lblAverageSound.text = "N/A"
            lblNoDataSound.isHidden = false
        }
        
        // Luz (LDR)
        if let sensor = sensors["LDR"], sensor.hasData {
            lblAverageLight.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataLight.isHidden = true
        } else {
            lblAverageLight.text = "N/A"
            lblNoDataLight.isHidden = false
        }
        
        // Vibración (VRB)
        if let sensor = sensors["VRB"], sensor.hasData {
            lblAverageVibration.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataVibration.isHidden = true
        } else {
            lblAverageVibration.text = "N/A"
            lblNoDataVibration.isHidden = false
        }
        
        // Movimiento (HAM)
        if let sensor = sensors["HAM"], sensor.hasData {
            lblAverageMovement.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataMovement.isHidden = true
        } else {
            lblAverageMovement.text = "N/A"
            lblNoDataMovement.isHidden = false
        }
        
        // Humedad (HUM)
        if let sensor = sensors["HUM"] ?? sensors["TAM"], sensor.hasData { // Algunos sistemas usan HUM o TAM para humedad
            lblAverageHumidity.text = formatValue(sensor.average, unit: sensor.unit)
            lblNoDataHumidity.isHidden = true
        } else {
            lblAverageHumidity.text = "N/A"
            lblNoDataHumidity.isHidden = false
        }
    }
    
    private func showNoDataMessage() {
        DispatchQueue.main.async {
            self.sensors.removeAll()
            self.lblNoDataFound.text = "No recorded data found."
            self.lblNoDataFound.isHidden = false
            
            // Ocultar todos los labels individuales de "No data"
            self.lblNoDataLight.isHidden = true
            self.lblNoDataTemperature.isHidden = true
            self.lblNoDataHumidity.isHidden = true
            self.lblNoDataSound.isHidden = true
            self.lblNoDataMovement.isHidden = true
            self.lblNoDataVibration.isHidden = true
            
            // Resetear todos los valores
            self.lblAverageTemperature.text = "N/A"
            self.lblAverageSound.text = "N/A"
            self.lblAverageLight.text = "N/A"
            self.lblAverageVibration.text = "N/A"
            self.lblAverageMovement.text = "N/A"
            self.lblAverageHumidity.text = "N/A"
        }
    }
    
    private func setupActivityIndicator() {
            view.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    private let activityIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .large)
           indicator.color = .gray
           indicator.translatesAutoresizingMaskIntoConstraints = false
           return indicator
       }()
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    @IBAction func dismissView() {
        dismiss(animated: true)
    }
}

struct SensorsResponse:Decodable {
    let incubator_id: Int?
    let total_readings: Int?
    let first_reading_time: String?
    let last_reading_time: String?
    let sensor_statistics: [String:Sensor]?
}

struct Sensor: Decodable{
    let average : Float?
    let min: Float?
    let max: Float?
    let count: Int?
    let first_reading: String?
    let last_reading: String?
    let range: Float?
    let unit: String?
    let message: String?
    var hasData: Bool {
            return message == nil
        }
}
