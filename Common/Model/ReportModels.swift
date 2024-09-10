//
//  ReportModels.swift
//  Omni
//
//  Created by ahmetAltintop on 11.08.2024.
//

import UIKit

enum ReportModels {
    
    //MARK: - Ana Grup Satış  -
    
    struct MainGroupSalesReportModel: Codable {
        let fiyat: Double
        let anaGrupAdi: String
        let subeAdi: String
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case fiyat = "FIYAT"
            case anaGrupAdi = "AGRUP2_ADI"
            case subeAdi = "SUBE_ADI"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct MGSRGroupedModel: Codable {
        let title: String
        var items: [MainGroupSalesReportModel]
        var totalAmount: Double
        var totalBranch: Int
        var isExpanded: Bool
        var isSortForBranch: Bool
    }
    
    //MARK: - En çok Satan Ürünler  -
    
    struct BestSellingProductModel: Codable{
        let subeAdi: String
        let urunNo: String
        let urunAdi: String
        let miktar: Double
        let tutar: Double
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case subeAdi = "SUBE_ADI"
            case urunNo = "URUN_NO"
            case urunAdi = "URUN_ADI"
            case miktar = "MIKTAR"
            case tutar = "TUTAR"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct BSPRGroupedModel: Codable {
        let title: String
        var items: [BestSellingProductModel]
        var totalAmount: Double
        var totalQuantity: Double
        var isExpanded: Bool
        var isSortForProduct: Bool
    }
    
    
    //MARK: - İndirim Detay  -
    
    struct DiscountDetailReportModel: Codable {
        let subeAdi: String
        let kasiyerAdi: String
        let masaNo: Int
        let indirimAdi: String
        let indirimTutari: Double
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case subeAdi = "SUBE_ADI"
            case kasiyerAdi = "KASIYER_ADI"
            case masaNo = "MASA_NO"
            case indirimAdi = "INDIRIM_ADI"
            case indirimTutari = "INDIRIM_TUTARI"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct DDRGroupedModel: Codable {
        let title: String
        var items: [DiscountDetailReportModel]
        var discountAmount: Double
        var totalChecks: Int
        var isExpanded: Bool
        var isSortForProduct: Bool
    }
    
    //MARK: - Ödeme Detay -
    
    struct PaymentDetailReportModel: Codable {
        let subeID: Int
        let subeAdi: String
        let odemeAdi: String
        let hesapSayisi: Int
        let toplam: Double
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case subeID = "FIRMA_ID"
            case subeAdi = "FIRMA_ADI"
            case odemeAdi = "ADI"
            case hesapSayisi = "HESAP_SAYISI"
            case toplam = "TOPLAM"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct PDRGroupedModel: Codable {
        let title: String
        var items: [PaymentDetailReportModel]
        var totalAmount: Double
        var totalAccount: Int
        var isExpanded: Bool
        var isSortForPayment: Bool
    }
    
    //MARK: - Ödenmez İkram -
    
    struct UnpaidGratuityReportModel: Codable {
        let subeAdi: String
        let indirimAdi: String
        let tutar: Double
        let tarih: String
        let personelAdi: String
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case subeAdi = "FIRMA_ADI"
            case indirimAdi = "INDIRIM_ADI"
            case tutar = "TUTAR"
            case tarih = "TARIH"
            case personelAdi = "PERSONEL"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct UGRGroupedModel: Codable {
        let title: String
        var items: [UnpaidGratuityReportModel]
        var totalAmount: Double
        var isExpanded: Bool
    }
    
    //MARK: - Gelir  -
    
    struct FinancialReportModel: Codable {
        let subeID: Int
        let subeAdi: String
        let toplamTutar: Double
        let kisiSayisi: Int
        let acikCekAdedi: Int
        let acikCekTutari: Double
        let sonXtarihi: String

        enum CodingKeys: String, CodingKey {
            case subeID = "FIRMA_ID"
            case subeAdi = "FIRMA_ADI"
            case toplamTutar = "TOPLAM_TUTAR"
            case kisiSayisi = "KISI_SAYISI"
            case acikCekAdedi = "ACIK_CEK_ADEDI"
            case acikCekTutari = "ACIK_CEK_TUTARI"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    //MARK: - Personel Satış -
    
    struct PersonnelSalesReportModel: Codable {
        let kasiyerAdi: String
        let subeAdi: String
        let kisiSayisi: Int
        let hesapSayisi: Int
        let toplamTutar: Double
        let sonXtarihi: String

        enum CodingKeys: String, CodingKey {
            case kasiyerAdi = "KASIYER_ADI"
            case subeAdi = "SUBE_ADI"
            case kisiSayisi = "KISI_SAYISI"
            case hesapSayisi = "HESAP_SAYISI"
            case toplamTutar = "KDV_DAHIL"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct PSRGroupedModel: Codable {
        let title: String
        var items: [PersonnelSalesReportModel]
        var totalPerson: Int
        var totalAccount: Int
        var totalAmount: Double
        var isExpanded: Bool
    }
    
    //MARK: - Açık Çekler  -

    struct OpenChecksReportModel: Codable {
        let subeID: Double
        let subeAdi: String
        let masaNo: Double
        let toplamTutar: Double
        let sonXtarihi: String
        
        enum CodingKeys: String, CodingKey {
            case subeID = "FIRMA_ID"
            case subeAdi = "FIRMA_ADI"
            case masaNo = "MASA_NO"
            case toplamTutar = "TOPLAM_TUTAR"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    struct OCRGroupedModel: Codable {
        let title: String
        var items: [OpenChecksReportModel]
        var totalAmount: Double
        var isExpanded: Bool
    }
    
    //MARK: - Sipariş Tipi -
    
    struct OrderTypeReportModel: Codable {
        let satisTuru: String
        let tutar: Double
        let kisiSayisi: Int
        let hesapSayisi: Int
        let sonXtarihi: String

        enum CodingKeys: String, CodingKey {
            case satisTuru = "SATIS_TURU"
            case tutar = "TUTAR"
            case kisiSayisi = "KISI_SAYISI"
            case hesapSayisi = "HESAP_SAYISI"
            case sonXtarihi = "SON_X_TARIHI"
        }
    }
    
    //MARK: - Login -
    
    struct LoginModel: Codable {
        let kullaniciID: Double

        enum CodingKeys: String, CodingKey {
            case kullaniciID = "KULLANICI_ID"
        }
    }
    
    //MARK: - LineChart -
    struct LineChartModel: Codable {
        let raporTarih: String
        let toplam: Double

        enum CodingKeys: String, CodingKey {
            case raporTarih = "RAPOR_GUNU"
            case toplam = "TOPLAM_KDV_DAHIL"
        }
    }
    
    struct DashboardDataModel {
        var totalPerson: String
        var totalAccount: String
        var totalBranch: String
        var totalDiscount: String
        var grandTotal: String
        var xDate: String
    }
}
