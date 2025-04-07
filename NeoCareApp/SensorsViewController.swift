//
//  SensorsViewController.swift
//  NeoCareApp
//
//  Created by Juan Gómez on 21/02/25.
//

import UIKit

class SensorsViewController: UIViewController {
    var selectedIncubator: Incubator?
    var sensors: [String:SensorData] = [:]
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var viewStatusTemp: UIView!
    @IBOutlet weak var viewStatusHumidity: UIView!
    let sensorsEndPoint = "http://34.215.209.108/api/v1/latest-sensor-data"
    @IBOutlet var backgroundSensors: [UIView]!
    @IBOutlet var backgroundSensorLbl: [UIView]!
    @IBOutlet var backgroundInfoSensor: [UIView]!
    @IBOutlet var backgroundStatus: [UIView]!
    @IBOutlet weak var lblAverageTemperature: UILabel!
    
    @IBOutlet weak var viewStatusVibration: UIView!
    @IBOutlet weak var viewStatusMovement: UIView!
    @IBOutlet weak var viewStatusSound: UIView!
    @IBOutlet weak var viewStatusLight: UILabel!
    @IBOutlet weak var viewStatusTempBaby: UIView!
    @IBOutlet weak var lblValueTemBaby: UILabel!
    @IBOutlet weak var lblNoDataTempBaby: UILabel!
    @IBOutlet weak var lblAverageSound: UILabel!
    @IBOutlet weak var lblAverageLight: UILabel!
    @IBOutlet weak var lblAverageVibration: UILabel!
    @IBOutlet weak var lblAverageMovement: UILabel!
    @IBOutlet weak var lblAverageHumidity: UILabel!
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
    
    @IBAction func refreshData() {
        btnRefresh.isEnabled = false 
        getSensors()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.btnRefresh.isEnabled = true
        }
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
                        self?.lblNoDataTempBaby.isHidden = false
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
            let response = try JSONDecoder().decode(SensorsResponse.self, from: data)
            print("API Response:", response)
            
            // Manejo de respuesta con mensaje de error
            if let errorMessage = response.message {
                showNoDataMessage(message: errorMessage)
                return
            }
            
            // Convertir la respuesta a diccionario
            let sensorData = response.sensorDictionary
            
            // Verificar si hay datos
            if sensorData.isEmpty {
                showNoDataMessage(message: "No recent sensor data available")
                return
            }
            
            self.lblNoDataFound.isHidden = true
            self.updateSensorUI(with: sensorData)
            self.updateSensorColors(sensorData: sensorData)
        } catch {
            showError(message: "Error processing the response.")
        }
    }
    private func updateSensorUI(with sensorData: [String: SensorData]) {
        guard !sensorData.isEmpty else {
            showNoDataMessage(message: "No sensor data to display")
            return
        }
        
        if let sensor = sensorData["TBB"], sensor.hasData {
            lblValueTemBaby.text = "\(sensor.floatValue ?? 0) °C"
            lblNoDataTempBaby.isHidden = true
        } else {
            lblValueTemBaby.text = "N/A"
            lblNoDataTempBaby.isHidden = false
        }
        
        if let sensor = sensorData["TAM"], sensor.hasData {
            lblAverageTemperature.text = "\(sensor.floatValue ?? 0) °C"
            lblNoDataTemperature.isHidden = true
        } else {
            lblAverageTemperature.text = "N/A"
            lblNoDataTemperature.isHidden = false
        }
        
        // Sonido (SON)
        if let sensor = sensorData["SON"], sensor.hasData {
            lblAverageSound.text = "\(sensor.floatValue ?? 0) dB"
            lblNoDataSound.isHidden = true
        } else {
            lblAverageSound.text = "N/A"
            lblNoDataSound.isHidden = false
        }
        
        // Movimiento (PRE)
        if let sensor = sensorData["PRE"], sensor.hasData {
            lblAverageMovement.text = "\(sensor.floatValue ?? 0) Pa"
            lblNoDataMovement.isHidden = true
        } else {
            lblAverageMovement.text = "N/A"
            lblNoDataMovement.isHidden = false
        }
        
        // Vibracion (VRB)
        if let sensor = sensorData["VRB"], sensor.hasData {
            lblAverageVibration.text = "\(sensor.floatValue ?? 0) m/s"
            lblNoDataVibration.isHidden = true
        } else {
            lblAverageVibration.text = "N/A"
            lblNoDataVibration.isHidden = false
        }
        
        // Vibracion (VRB)
        if let sensor = sensorData["LDR"], sensor.hasData {
            lblAverageLight.text = "\(sensor.floatValue ?? 0) lux"
            lblNoDataLight.isHidden = true
        } else {
            lblAverageLight.text = "N/A"
            lblNoDataLight.isHidden = false
        }
        
        if let sensor = sensorData["HAM"], sensor.hasData {
            lblAverageHumidity.text = "\(sensor.floatValue ?? 0) %"
            lblNoDataHumidity.isHidden = true
        } else {
            lblAverageHumidity.text = "N/A"
            lblNoDataHumidity.isHidden = false
        }
        
        
    }
    
    func getColorForTemperature(temp: Float) -> UIColor {
        if temp >= 32 {
            return UIColor.red // Rojo si la temperatura es mayor o igual a 32
        } else if temp >= 25 {
            return UIColor.yellow // Amarillo si la temperatura es mayor o igual a 25
        } else if temp >= 20 {
            return UIColor.green // Verde si la temperatura es mayor o igual a 20
        } else {
            return UIColor.red // Rojo si la temperatura es menor a 20
        }
    }
    
    func getColorForVibration(value: Float) -> UIColor {
        return value == 1 ? UIColor.green : UIColor.red // Si hay vibración, verde; si no, rojo
    }
    
    func getColorForSound(value: Float) -> UIColor {
        if value > 85 {
            return UIColor.red // Peligroso (rojo)
        } else if value >= 60 {
            return UIColor.orange // Fuerte (naranja)
        } else if value >= 30 {
            return UIColor.yellow // Moderado (amarillo)
        } else {
            return UIColor.green // Bajo (verde)
        }
    }
    
    func getColorForMovement(value: Float) -> UIColor {
        return value == 0 ? UIColor.gray : UIColor.green // Sin movimiento (gris), con movimiento (verde)
    }
    
    func getColorForLight(value: Float) -> UIColor {
        if value > 800 {
            return UIColor.yellow // Brillante (amarillo)
        } else if value >= 400 {
            return UIColor.green // Normal (verde)
        } else {
            return UIColor.red // Bajo (rojo)
        }
    }
    
    func getColorForHumidity(humidity: Float) -> UIColor {
        if humidity < 40 {
            return UIColor.red // Baja (rojo)
        } else if humidity < 70 {
            return UIColor.yellow // Media (amarillo)
        } else {
            return UIColor.green // Alta (verde)
        }
    }
    
    func updateSensorColors(sensorData: [String: SensorData]) {
        // Para cada sensor, actualizamos los colores de fondo de los UIView
        if let tempSensor = sensorData["TAM"], let tempValue = tempSensor.floatValue {
            viewStatusTemp.backgroundColor = getColorForTemperature(temp: tempValue)
        }
        
        if let vibrationSensor = sensorData["VRB"], let vibrationValue = vibrationSensor.floatValue {
            viewStatusVibration.backgroundColor = getColorForVibration(value: vibrationValue)
        }
        
        if let soundSensor = sensorData["SON"], let soundValue = soundSensor.floatValue {
            viewStatusSound.backgroundColor = getColorForSound(value: soundValue)
        }
        
        if let movementSensor = sensorData["PRE"], let movementValue = movementSensor.floatValue {
            viewStatusMovement.backgroundColor = getColorForMovement(value: movementValue)
        }
        
        if let lightSensor = sensorData["LDR"], let lightValue = lightSensor.floatValue {
            viewStatusLight.backgroundColor = getColorForLight(value: lightValue)
        }
        
        if let humiditySensor = sensorData["HAM"], let humidityValue = humiditySensor.floatValue {
            viewStatusHumidity.backgroundColor = getColorForHumidity(humidity: humidityValue)
        }
    }
    
    private func showNoDataMessage(message: String = "No recorded data found") {
        DispatchQueue.main.async {
                self.lblNoDataFound.text = message
                self.lblNoDataFound.isHidden = false
                
                // Resetear todos los valores
                self.lblAverageTemperature.text = "N/A"
                self.lblAverageSound.text = "N/A"
                self.lblAverageLight.text = "N/A"
                self.lblAverageVibration.text = "N/A"
                self.lblAverageMovement.text = "N/A"
                self.lblAverageHumidity.text = "N/A"
                self.lblValueTemBaby.text = "N/A"
                
                // Mostrar todos los labels de "No data"
                self.lblNoDataTemperature.isHidden = false
                self.lblNoDataSound.isHidden = false
                self.lblNoDataLight.isHidden = false
                self.lblNoDataVibration.isHidden = false
                self.lblNoDataMovement.isHidden = false
                self.lblNoDataHumidity.isHidden = false
                self.lblNoDataTempBaby.isHidden = false
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
    let message: String? // Solo para errores (404)
    let TAM: SensorData?
    let HAM: SensorData?
    let TBB: SensorData?
    let LDR: SensorData?
    let SON: SensorData?
    let VRB: SensorData?
    let PRE: SensorData?
    
    // Computed property para acceder a todos los sensores como diccionario
    var sensorDictionary: [String: SensorData] {
        var dict = [String: SensorData]()
        if let tam = TAM { dict["TAM"] = tam }
        if let ham = HAM { dict["HAM"] = ham }
        if let tbb = TBB { dict["TBB"] = tbb }
        if let ldr = LDR { dict["LDR"] = ldr }
        if let son = SON { dict["SON"] = son }
        if let vrb = VRB { dict["VRB"] = vrb }
        if let pre = PRE { dict["PRE"] = pre }
        return dict
    }
}

struct SensorData: Decodable{
    let value: String?
    let date: String?
    
    var hasData: Bool {
        return value != nil && date != nil
    }
    
    var floatValue: Float? {
        return value.flatMap { Float($0) }
    }
}
