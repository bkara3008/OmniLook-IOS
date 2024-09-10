//
//  LanguageManager.swift
//  Omni
//
//  Created by ahmetAltintop on 2.08.2024.
//

import UIKit

class LanguageManager {
    static let shared = LanguageManager()

    private let languageKey = "selectedLanguage"
    
    var currentLanguage: String {
        return UserDefaults.standard.string(forKey: languageKey) ?? "tr"
    }
    
    func setLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: languageKey)
        Bundle.setLanguage(language)
        
        if let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> {
            for windowScene in scenes {
                for window in windowScene.windows {
                    updateRootViewController(window: window)
                }
            }
        }
    }
    
    private func updateRootViewController(window: UIWindow) {
        let homeViewController = HomeViewController() // Buraya kendi HomeViewController'ınızı koyun
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
}
