//
//  Constants.swift
//  Omni
//
//  Created by ahmetAltintop on 15.08.2024.
//

import Foundation

enum Constants {
    static let testUrl = "http://78.189.33.68:82/OmniAPI"
    static let testUrl2 = "http://82.222.47.141/OmniAPI"
    
    enum UserDefaults {
        static let savedUrlKey =  "ServerURL"
        static let savedCurrencyKey = "SelectedCurrency"
        static let savedStartDateKey = "SelectedStartDate"
        static let savedEndDateKey = "SelectedEndDate"
        static let savedFirmIDsKey = "SelectedFirmIDs"
        static let userID = "UserID"
        static let SelectedLanguageKey = "SelectedLanguage"
        static let userName = "Username"
        static let password = "Password"
    }
}
