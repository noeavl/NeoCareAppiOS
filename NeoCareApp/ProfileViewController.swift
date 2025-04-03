//
//  ProfileViewController.swift
//  NeoCareApp
//
//  Created by Noe  on 19/02/25.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblRfc: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var imvProfile: UIImageView!
    let loginEndpoint = "http://34.215.209.108/api/v1/sessions/logout"
    let profileEndpoint = "http://34.215.209.108/api/v1/profile/me"

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    
    @IBAction func regresar() {
        dismiss(animated: true)
    }
    
    @IBAction func logout() {
        
        let alert = UIAlertController(
                title: "Log Out",
                message: "Are you sure you want to log out of your account?",
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            
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
                
            AuthManager.shared.logout()
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
    }
    
    private func getProfile() {
        do {
            let request = try self.createURLRequestProfile()
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showToast(message: "\(error.localizedDescription)", title: "Network Error")
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self?.showToast(message: "No se recibió información", title: "Error")
                    }
                    return
                }
                
                do {
                    let profileResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.lblFullName.text = profileResponse.data.full_name
                        self?.lblEmail.text = profileResponse.data.email
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.showToast(message: "Error al procesar los datos: \(error.localizedDescription)", title: "Parsing Error")
                    }
                }
            }.resume()
        } catch {
            self.showToast(message: "Error creando la solicitud.", title: "Request Error")
        }
    }

    
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
    
    private func createURLRequestProfile() throws -> URLRequest {
        guard let url = URL(string: profileEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(String("application/json"), forHTTPHeaderField: "Content-Type")
        if let token = AuthManager.shared.loadToken() {
            request.addValue(String("Bearer \(token)"), forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
}

struct ProfileResponse: Codable {
    let data: ProfileData
}

struct ProfileData: Codable {
    let full_name: String
    let email: String
    let rfc: String?
}

