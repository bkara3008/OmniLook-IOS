//
//  UIView.Ext.swift
//  Omni
//
//  Created by ahmetAltintop on 23.08.2024.
//

import Foundation
import UIKit

extension UIView {
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
}
