//
//  HomeModels.swift
//  Omni
//
//  Created by ahmetAltintop on 18.07.2024.
//

import UIKit


enum HomeModels {
    
    enum HomeBottomButtonTypes {
        case settings
        case exit
    }
    
    enum TempReportTypes: String, CaseIterable {
        case gelir =  "Gelir Raporu"
        case enCokSatanUrunler = "En Çok Satan Ürünler Raporu"
        case siparisTipi = "Sipariş Tipi Raporu"
        case personelSatis = "Personel Satış Raporu"
        case acikCekler = "Açık Çekler Raporu"
        case anaGrupSatis = "Ana Grup Satış Raporu"
        case indirimDetay = "İndirim Detay Raporu"
        case odenmezIkram = "Ödenmez İkram Raporu"
        case odemeDetay = "Ödeme Detay Raporu"
    }
    
    // rapor adeti kadar renk var. şu an kullanılmıyor silinebilir. .
    enum ColorTypes: CaseIterable {
        case appLightRed
        case appLightBlue
        case appLightGray
        case appLightBlue2
        case appLightGreen
        case appLightOrange
        case appLightPurple
        case appLightPink
        case appLightYellow
        
        var colors: UIColor {
            switch self {
            case .appLightRed:
                return .appLightRed
            case .appLightBlue:
                return .appLightBlue
            case .appLightGray:
                return .appLightGray
            case .appLightBlue2:
                return .appLightBlue2
            case .appLightGreen:
                return .appLightGreen
            case .appLightOrange:
                return .appLightOrange
            case .appLightPurple:
                return .appLightPurple
            case .appLightYellow:
                return .appLightYellow
            case .appLightPink:
                return .appLightPink
            }
        }
    }
    
    enum DashboardTitles: String, CaseIterable {
        case totalBranch = "Total_Branch"
        case totalCiro = "Total_Turnover"
        case totalAcount = "Total_Account_"
        case totalDiscount = "Total_Discount"
        case totalPerson = "Total_Person"
    }
    
    struct FirmListModel: Codable {
        let firmaID: Int
        let firmaAdi: String
        var firmaGrupID: Int?

        enum CodingKeys: String, CodingKey {
            case firmaID = "FIRMA_ID"
            case firmaAdi = "FIRMA_ADI"
        }
        init(firmaID: Int, firmaAdi: String, firmaGrupID: Int?) {
            self.firmaID = firmaID
            self.firmaAdi = firmaAdi
            self.firmaGrupID = firmaGrupID
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.firmaID = try container.decode(Int.self, forKey: .firmaID)
            self.firmaAdi = try container.decode(String.self, forKey: .firmaAdi)
            self.firmaGrupID = nil // JSON'dan gelmediği için manuel olarak nil yapıyoruz
        }
    }
    
    struct FirmGroupListModel: Codable {
        let firmaGrupID: Int
        let grupAdi: String
        
        enum CodingKeys: String, CodingKey {
            case firmaGrupID = "FIRMA_GRUBU_ID"
            case grupAdi = "GRUP_ADI"
        }
    }
    
    enum Currencies: Int, CaseIterable {
        case def = 1
        case tl = 2
        case euro = 3
        case usd = 4
    }
    
}
