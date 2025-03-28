//
//  AuthManager.swift
//  NeoCareApp
//
//  Creado usando NSObject para:
//  1. Mayor interoperabilidad con código Objective-C si fuera necesario
//  2. Posibilidad de usar selectores y métodos de NSObject
//  3. Mantener un estilo familiar para desarrolladores con experiencia en Objective-C
//

import Foundation
import Security
import UIKit

class AuthManager: NSObject {
    // MARK: - Singleton Pattern
    // Instancia compartida estática para acceso global
    static let shared = AuthManager()
    
    // Inicializador privado para prevenir múltiples instancias
    private override init() {
        super.init()
        loadAuthData()
        print("AuthManager inicializado")
    }
    
    // MARK: - Propiedades
    // Almacenamiento seguro del token usando Keychain
    private let keychainService = "com.NeoCareApp.authToken"
    private let userDefaults = UserDefaults.standard
    private let hospitalIdKey = "hospitalId"
    private let roleKey = "userRole"
    
    // Token en memoria para acceso rápido
    private var currentToken: String?
    private var hospitalId: Int?
    private var userRole: String?
    
    // MARK: - Gestión del Token
    /// Guarda el token en Keychain y memoria
    /// - Parameter token: String con el token JWT/autenticación
    func saveToken(_ token: String) {
        // 1. Guardar en memoria
        currentToken = token
        
        // 2. Convertir a Data para Keychain
        guard let data = token.data(using: .utf8) else {
            print("Error: Fallo en conversión a Data")
            return
        }
        
        // 3. Configurar query para Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Tipo de elemento seguro
            kSecAttrService as String: keychainService,     // Identificador único
            kSecValueData as String: data                   // Datos a guardar
        ]
        
        // 4. Eliminar existencia previa
        SecItemDelete(query as CFDictionary)
        
        // 5. Añadir nuevo item
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error Keychain: \(status)")
            return
        }
        
        print("Token guardado exitosamente")
    }
    
    /// Carga el token desde Keychain
    /// - Returns: String con el token o nil
    func loadToken() -> String? {
        // 1. Si ya está en memoria, devolverlo
        if let token = currentToken {
            return token
        }
        
        // 2. Query para recuperación
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecReturnData as String: true,       // Devolver Data
            kSecMatchLimit as String: kSecMatchLimitOne // Solo un resultado
        ]
        
        // 3. Recuperar datos
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // 4. Manejar resultado
        guard status == errSecSuccess else {
            print("Error carga Keychain: \(status)")
            return nil
        }
        
        guard let data = dataTypeRef as? Data,
              let token = String(data: data, encoding: .utf8) else {
            print("Error: Conversión de Data fallida")
            return nil
        }
        
        // 5. Actualizar memoria y devolver
        currentToken = token
        return token
    }
    
    /// Elimina el token de Keychain y memoria
    func deleteToken() {
        // 1. Eliminar de memoria
        currentToken = nil
        
        // 2. Query para eliminación
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService
        ]
        
        // 3. Ejecutar eliminación
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print("Error eliminación Keychain: \(status)")
            return
        }
        
        print("Token eliminado exitosamente")
    }
    
    // MARK: - Gestión de Sesión
    /// Verifica estado de autenticación
    var isLoggedIn: Bool {
        return loadToken() != nil
    }
    
    /// Cierra sesión y limpia datos
    func logout() {
        // 1. Eliminar token
        deleteToken()
        userDefaults.removeObject(forKey: roleKey)
        userDefaults.removeObject(forKey: hospitalIdKey)
        userRole = nil
        hospitalId = nil
        
        // 2. Notificar al sistema
        NotificationCenter.default.post(name: .didLogout, object: nil)
       
    }
    
    func saveAuthData(token: String, role:String, hospitalId: Int){
        saveToken(token)
        saveRole(role)
        saveHospitalId(hospitalId)
    }
    func saveRole(_ role:String){
        userRole = role
        userDefaults.set(role, forKey: roleKey)
    }
    func saveHospitalId(_ id:Int){
        hospitalId = id
        userDefaults.set(id, forKey: hospitalIdKey)
    }
    func loadAuthData(){
        userRole = userDefaults.string(forKey: roleKey)
        hospitalId = userDefaults.integer(forKey: hospitalIdKey)
    }
    func getRole() -> String?{
        return userRole
    }
    func getHospitalId() -> Int?{
        return hospitalId
    }
}

// MARK: - Extensiones
extension Notification.Name {
    static let didLogout = Notification.Name("didLogoutNotification")
}

// MARK: - Uso recomendado
/*
// Para guardar token:
AuthManager.shared.saveToken("tu_token_jwt_aqui")

// Para obtener token:
if let token = AuthManager.shared.loadToken() {
    print("Token recuperado: \(token)")
}

// Para cerrar sesión:
AuthManager.shared.logout()
*/
