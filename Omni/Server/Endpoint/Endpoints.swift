//
//  Endpoints.swift
//  Omni
//
//  Created by ahmetAltintop on 16.08.2024.
//

import Foundation

enum ReportUrl: String, CaseIterable {
    case gelir =  "OMNI_RPT_MBL_KASA_SATIS"
    case enCokSatanUrunler = "OMNI_RPT_MBL_COK_SATILAN_URUNLER"
    case siparisTipi = "OMNI_RPT_MBL_SIPARIS_TIPI"
    case personelSatis = "OMNI_RPT_MBL_PERSONEL"
    case acikCekler = "OMNI_RPT_MBL_ACIK_CEKLER"
    case anaGrupSatis = "OMNI_RPT_MBL_ANA_GRUP_2_SATIS"
    case indirimDetay = "OMNI_RPT_MBL_INDIRIM_DETAY"
    case odenmezIkram = "OMNI_RPT_MBL_ODENMEZ_IKRAM"
    case odemeDetay = "OMNI_RPT_MBL_KASA_SATIS_ODEME"
    case lineChartData = "OMNI_RPT_MBL_DASHBOARD_DATA"
}

struct Endpoints {
    private let baseURL: String
    private let kullaniciID: String
    private let firmaID: String
    private let tarih1: String
    private let tarih2: String
    private let currCode: String
    
    init(baseURL: String, kullaniciID: String, firmaID: String, tarih1: String, tarih2: String, currCode: String) {
        self.baseURL = baseURL
        self.kullaniciID = kullaniciID
        self.firmaID = firmaID
        self.tarih1 = tarih1
        self.tarih2 = tarih2
        self.currCode = currCode
    }
    
    //Tüm raporların Endpoint'i
    func getUrl(for reportType: ReportUrl) -> String {
        return "\(baseURL)/home/\(reportType.rawValue)?kullaniciid=\(kullaniciID)&firmaid=\(firmaID)&tarih1=\(tarih1)&tarih2=\(tarih2)&curr=\(currCode)"
    }
    
    // Base URL (AppConfig ile dinamik olarak alınıyor)
    static var baseURL: String {
        return AppConfig.shared.serverUrl
    }
    
    // FIRMA_GRUBU Endpoint'i
    static var firmGroup: String {
        return "\(baseURL)/home/FIRMA_GRUBU"
    }
    
    // OMNI_RPT_MBL_KASA_SATIS Endpoint'i
    static func getFinancialReport(kullaniciId: String, firmaId: String, startDate: String, endDate: String, currencyCode: String) -> String {
        return "\(baseURL)/home/OMNI_RPT_MBL_KASA_SATIS?kullaniciid=\(kullaniciId)&firmaid=\(firmaId)&tarih1=\(startDate)&tarih2=\(endDate)&curr=\(currencyCode)"
    }
}
