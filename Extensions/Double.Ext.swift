//
//  Double.Ext.swift
//  Omni
//
//  Created by ahmetAltintop on 13.08.2024.
//

import Foundation

extension Double {
    func formatCurrency(currency: HomeModels.Currencies) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        switch currency {
        case .def:
            numberFormatter.currencyCode = ""
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = ""
        case .tl:
            numberFormatter.currencyCode = "TRY"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = "₺ "
        case .euro:
            numberFormatter.currencyCode = "EUR"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = " €"
        case .usd:
            numberFormatter.currencyCode = "USD"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = "$ "
        }
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
