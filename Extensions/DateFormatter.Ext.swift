//
//  DateFormatter.Ext.swift
//  Omni
//
//  Created by ahmetAltintop on 12.08.2024.
//

import Foundation

extension DateFormatter {
    // Tarihi string formatında formatlayan fonksiyon
    static func string(from date: Date, format: String = "dd.MM.yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func longStringDate(from date: Date, format: String = "dd.MM.yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
     
     // String'den Date nesnesine dönüştüren fonksiyon
    static func toDate(from string: String, format: String = "dd.MM.yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}
