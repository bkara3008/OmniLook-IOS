//
//  UIViewController.Ext.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

extension UIViewController {
    private static var appCurrency = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey)
    
    private static var loaderViewTag: Int { return 999999 }
    
    func showLoader() {
        DispatchQueue.main.async {
            let loaderView = UIView(frame: self.view.bounds)
            loaderView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            loaderView.tag = UIViewController.loaderViewTag
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = loaderView.center
            activityIndicator.startAnimating()
            activityIndicator.color = .appBlue
            
            loaderView.addSubview(activityIndicator)
            self.view.addSubview(loaderView)
            
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.view.viewWithTag(UIViewController.loaderViewTag)?.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showAlert(message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Tamam"), style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    
    func getAppCurrency() -> HomeModels.Currencies {
        let curr = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey) as? String
        if curr == "USD" {
            return .usd
        }else if curr == "TL"{
            return .tl
        }else if curr == "EUR" {
            return .euro
        }else if curr == "DEF" {
            return .def
        }else {
            return .def
        }
    }
    
    func getAppLanguage() -> SettingsModel.Languages {
        let lang = UserDefaults.standard.object(forKey: Constants.UserDefaults.SelectedLanguageKey) as? String
        if lang == "Turkish" {
            return .tr
        }else {
            return .en
        }
    }
}
