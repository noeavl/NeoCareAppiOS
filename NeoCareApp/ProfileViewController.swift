//
//  ProfileViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 19/02/25.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imvProfile: UIImageView!
    let loginEndpoint = "http://34.215.209.108/api/v1/sessions/logout"
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
            
                // Consumo de la ruta de logout para borrar el token de la API
                do{
                    let request = try self.createURLRequest()
                    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                        if let error = error {
                            self?.showToast(message: "\(error.localizedDescription)", title: "Network Error")
                        }
                        
                        let statusCode: Int
                        if let httpResponse = response as? HTTPURLResponse {
                            statusCode = httpResponse.statusCode
                        } else {
                            statusCode = 0
                            self?.showToast(message: "Invalid Response.")
                        }
                        DispatchQueue.main.async {
                            switch statusCode {
                            case 200...299:
                                self?.showToast(message: "Log Out Successfully", title: "Success")
                            default:
                                self?.showToast(message: "Please log in again.", title: "Error")
                            }
                        }
                    }.resume()
                }catch{
                    self.showToast(message: "Error creating the request.")
                }
                
            // Borrar el token del singleton y redireccionar.
            AuthManager.shared.logout()
            }
            
            // Acción para cancelar
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
    }
    
    // Alerta/Toast se quita automaticamente.
    private func showToast(message: String,
                          duration: TimeInterval = 1.5,
                          title: String? = nil,
                          alertStyle: UIAlertController.Style = .alert) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: alertStyle
            )
            
            self.present(alert, animated: true)
            
            // Temporizador para cerrar automáticamente
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                // Cerrar alerta y redireccion al Login.
                alert.dismiss(animated: true){
                    self.performSegue(withIdentifier: "sgProfileLogin", sender: nil)
                }
            }
        }
    }
    
    private func createURLRequest() throws -> URLRequest {
        guard let url = URL(string: loginEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = AuthManager.shared.loadToken() {
            request.addValue(String("Bearer \(token)"), forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
}
