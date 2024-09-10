//
//  String.Ext.swift
//  Omni
//
//  Created by ahmetAltintop on 23.08.2024.
//

import UIKit
import CommonCrypto

extension String {
    func translated() -> String {
        var LocalizeDefaultLanguage = UserDefaults.standard.string(forKey: Constants.UserDefaults.SelectedLanguageKey)
        if LocalizeDefaultLanguage == SettingsModel.Languages.tr.rawValue {
            LocalizeDefaultLanguage = "tr"
        }else {
            LocalizeDefaultLanguage = "en"
        }
        if let path = Bundle.main.path(forResource: LocalizeDefaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(self, bundle: bundle, comment: "")
        }
        
        return ""
    }
    
    func hashMD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
