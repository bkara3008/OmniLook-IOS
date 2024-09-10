//
//  AppConfig.swift
//  Omni
//
//  Created by ahmetAltintop on 16.08.2024.
//

import Foundation

class AppConfig {
    static let shared = AppConfig()
    
    private init() {} // Başka yerlerden bu sınıfı oluşturmayı engeller
    
    var serverUrl: String {
        return UserDefaults.standard.object(forKey: Constants.UserDefaults.savedUrlKey) as? String ?? ""
    }
    
    func getUrl(for endpoint: String) -> String {
        return "\(serverUrl)/home/\(endpoint)"
    }
}
