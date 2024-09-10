//
//  DashboardService.swift
//  Omni
//
//  Created by ahmetAltintop on 5.09.2024.
//

import UIKit

class DashboardService {
    static let shared = DashboardService()
    
    // Dashboard verileri
    private(set) var dashboardData: [ReportModels.DashboardDataModel] = []
    private(set) var financialData: [ReportModels.FinancialReportModel] = []
    private(set) var discountData: [ReportModels.DiscountDetailReportModel] = []
    private(set) var orderTypeData: [ReportModels.OrderTypeReportModel] = []
    
    private(set) var activeBranches: [String] = []
    private(set) var allBranchIDs: [Int] = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedFirmIDsKey) as? [Int] ?? [-1]

    private init() {}
    
    
    // Dashboard verisine erişim
    func getDashboardData() -> [ReportModels.DashboardDataModel] {
        return dashboardData
    }
    
    // Get Data Part
    func getAllDashboardData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        self.geFinancialData { [weak self] isTodayDataAvailable in
            guard let self = self else { return }

            if isTodayDataAvailable {
                // Bugünün verisi varsa diğer verileri bugüne göre çek
                self.getOtherDataForDate(date: Date(), dispatchGroup: dispatchGroup)
            } else {
                // Dünkü veriyi kullan ve diğer verileri düne göre çek
                if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                    self.getOtherDataForDate(date: yesterday, dispatchGroup: dispatchGroup)
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.prepareDashData()
            completion() // Veriler yüklendiğinde completion block'u çağır
        }
    }
    
    func getOtherDataForDate(date: Date, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        self.getDiscountData(for: date) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.getOrderTypeData(for: date) {
            dispatchGroup.leave()
        }
    }
    
    func geFinancialData(completion: @escaping (Bool) -> Void) {
        // Önce bugünün tarihini kullanarak veri çekiyoruz
        let todayDate = DateFormatter.string(from: Date(), format: "dd.MM.yyyy")
        self.fetchFinancialData(for: todayDate) { isTodayDataAvailable in
            if isTodayDataAvailable {
                completion(true) // Bugünün verisi geçerli, işleme devam ediyoruz
            } else {
                // Eğer bugünün verisi geçersizse, bir önceki günü kullanıyoruz
                if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                    let yesterdayDate = DateFormatter.string(from: yesterday, format: "dd.MM.yyyy")
                    self.fetchFinancialData(for: yesterdayDate) { _ in
                        completion(false) // Dünün verisi kullanıldı
                    }
                } else {
                    completion(false) // Eğer bir önceki gün hesaplanamazsa, false döneriz
                }
            }
        }
    }
    
    func fetchFinancialData(for date: String, completion: @escaping (Bool) -> Void) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: date, // Sadece belirli bir günü kullanıyoruz
                                 tarih2: date,
                                 currCode: commonParameters.currCode)
        
        let financialUrl = endpoint.getUrl(for: .gelir)
        
        guard let url = URL(string: financialUrl) else {
            fatalError("Geçersiz URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(false)
                return
            }
            
            do {
                self.financialData = try JSONDecoder().decode([ReportModels.FinancialReportModel].self, from: data)
                
                let isTodayDataAvailable = !self.financialData.isEmpty
                
                completion(isTodayDataAvailable)
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    func getDiscountData(for date: Date, completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // API'nin beklediği tarih formatını kullanın
        let dateString = dateFormatter.string(from: date)
        
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: dateString,
                                 tarih2: dateString,  // Aynı tarihe göre veri çekecek
                                 currCode: commonParameters.currCode)
        
        let discountUrl = endpoint.getUrl(for: .indirimDetay)
        
        guard let url = URL(string: discountUrl) else {
            fatalError("Geçersiz URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion()
                return
            }
            
            do {
                self.discountData = try JSONDecoder().decode([ReportModels.DiscountDetailReportModel].self, from: data)
                DispatchQueue.main.async {
                    print(self.discountData.count)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
            completion()
        }.resume()
    }
    
    func getOrderTypeData(for date: Date, completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // API'nin beklediği tarih formatını kullanın
        let dateString = dateFormatter.string(from: date)
        
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: dateString,
                                 tarih2: dateString,  // Aynı tarihe göre veri çekecek
                                 currCode: commonParameters.currCode)
        
        let orderTypeUrl = endpoint.getUrl(for: .siparisTipi)
        
        guard let url = URL(string: orderTypeUrl) else {
            fatalError("Geçersiz URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion()
                return
            }
            
            do {
                self.orderTypeData = try JSONDecoder().decode([ReportModels.OrderTypeReportModel].self, from: data)
                DispatchQueue.main.async {
                    print(self.orderTypeData.count)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
            completion()
        }.resume()
    }
    //
    
    private func getCurrencyCode(savedCurrency: String) -> Int {
        if savedCurrency == "USD" {
            return 4
        }else if savedCurrency == "TL" {
            return 2
        }else if savedCurrency == "EUR" {
            return 3
        }else { // default bu kısım
            return 1
        }
    }
    
    private func getCommonParameters() -> (currCode: String, startDate: String, endDate: String, firmIDs: String, userID: String) {
        
        let savedCurr = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey) ?? "USD"
        let currCode = getCurrencyCode(savedCurrency: savedCurr as! String)
        
        let userID = UserDefaults.standard.string(forKey: Constants.UserDefaults.userID) ?? "-1"
        
        let currentDate = Date()
        
        let startDate = DateFormatter.string(from: currentDate)
        let endDate = DateFormatter.string(from: currentDate)
        
        var IDs: [Int] = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedFirmIDsKey) as? [Int] ?? [-1]
        if IDs.isEmpty {
            IDs = [-1]
        }
        let firmIDs = IDs.map { String($0) }.joined(separator: ",")
        
        return ("\(currCode)", startDate, endDate, firmIDs, userID)
    }
    
    private func prepareDashData() {
        
        let totalPerson = "\(self.financialData.reduce(0){$0 + $1.kisiSayisi})"
        let grandTotal = "\(self.financialData.reduce(0){$0 + $1.toplamTutar})"
        
        self.activeBranches = Array(Set(self.financialData.map {$0.subeAdi}))
        let allBranches = !self.allBranchIDs.isEmpty ? self.allBranchIDs.count : 0
        
        let totalBranch = "\(activeBranches.count)/\(allBranches)"
        let totalDiscount = "\(self.discountData.reduce(0){$0 + $1.indirimTutari})"
        let totalChecks = "\(self.orderTypeData.reduce(0){$0 + $1.hesapSayisi})"
        var date = ""
        
        // Eğer bugün data yoksa dünün tarihi ve dd.mm.yyyy formatlı olacak. Bugün data varsa uzun formatlı tarih olacak
        if let firstFinancialRecord = financialData.first,
           let sonXDate = DateFormatter.toDate(from: firstFinancialRecord.sonXtarihi, format: "yyyy-MM-dd'T'HH:mm:ss"),
           let year = Calendar.current.dateComponents([.year], from: sonXDate).year,
           year != 1900 {
            if Calendar.current.isDateInToday(sonXDate) {
                // Tarih bugüne eşitse, sonXDate tarihini döndür
                date = DateFormatter.longStringDate(from: sonXDate)
            } else {
                // Tarih bugüne eşit değilse, sonXDate'i "dd.MM.yyyy" formatında döndür
                let dateString = DateFormatter.string(from: sonXDate, format: "dd.MM.yyyy")
                date = dateString
            }
        } else {
            // Tarih 1900, nil veya null ise, dünün tarihini döndür
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            date = DateFormatter.string(from: yesterday, format: "dd.MM.yyyy")
        }
        
        self.dashboardData.removeAll()
        self.dashboardData.append(ReportModels.DashboardDataModel(totalPerson: totalPerson,
                                                                  totalAccount: totalChecks,
                                                                  totalBranch: totalBranch,
                                                                  totalDiscount: totalDiscount,
                                                                  grandTotal: grandTotal,
                                                                  xDate: date))
    }

}
