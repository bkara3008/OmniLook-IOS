//
//  SettingsModel.swift
//  Omni
//
//  Created by ahmetAltintop on 1.08.2024.
//

import Foundation
import UIKit

enum SettingsModel {
    
    enum Currency: String, CaseIterable{
        case def = "Default"
        case tl = "TL"
        case eur = "EUR"
        case usd = "USD"
    }
    
    enum Languages: String, CaseIterable{
        case tr = "Turkish"
        case en =  "English"
    }
    
    enum SettingsItems {
        case language
        case currency
    }
}
