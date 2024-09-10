//
//  MainMenuViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 11.07.2024.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
        self.getLineChartData()
//        self.fetchDashData()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDashData()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Internal -
    
    //MARK: - Public -
    
    var dashboardData: [ReportModels.DashboardDataModel] = []
    var allFirmList: [HomeModels.FirmListModel] = []
    var firmGroupList: [HomeModels.FirmGroupListModel] = []
    var activeBranches: [String] = []
    
    //MARK: - Private -
//    private let refreshControl = UIRefreshControl()
    private let modalPresentDelegate = ModalPresentationViewDelegate()
    
    private var currency: HomeModels.Currencies = .def
    private var userID = UserDefaults.standard.string(forKey: Constants.UserDefaults.userID)
    
    // Report Arrays
    private var bestSellingProduct: [ReportModels.BestSellingProductModel] = []
    private var anaGrupSatis: [ReportModels.MainGroupSalesReportModel] = []
    private var discountDetail: [ReportModels.DiscountDetailReportModel] = []
    private var paymentDetail: [ReportModels.PaymentDetailReportModel] = []
    private var financial: [ReportModels.FinancialReportModel] = []
    private var personnel: [ReportModels.PersonnelSalesReportModel] = []
    private var openChecks: [ReportModels.OpenChecksReportModel] = []
    private var unpaidGratuity: [ReportModels.UnpaidGratuityReportModel] = []
    private var orderType: [ReportModels.OrderTypeReportModel] = []
    private var lineChartData: [ReportModels.LineChartModel] = []
    //
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.refreshControl = self.refreshControl
        return scroll
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshDashboardData), for: .valueChanged)
        return refresh
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var homeTotalView: HomeAllResultsView  = {
        let view = HomeAllResultsView()
        if self.dashboardData.count == 0 {
            view.configure(data: ReportModels.DashboardDataModel(totalPerson: "", totalAccount: "", totalBranch: "", totalDiscount: "", grandTotal: "", xDate: ""), currency: self.currency)
        }else {
            view.configure(data: self.dashboardData[0], currency: self.currency)
        }
        view.delegate = self
        return view
    }()
    
    private lazy var weeklyLineChart: RevenueChartView = {
        let view = RevenueChartView()
        return view
    }()
    
    private lazy var homeReportsView: HomeReportsView = {
        let view = HomeReportsView()
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dateXLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .loginBG
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(.cikis, for: .normal)
        button.addTarget(self, action: #selector(self.exitButton_Tapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 13
        return button
    }()
    
    //MARK: - Private Functions -
    
    private func prepareViews() {
        self.currency = getAppCurrency()
        
        self.view.backgroundColor = .clear
        
        self.view.addSubview(self.bgImageView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.weeklyLineChart)
        self.containerView.addSubview(self.homeTotalView)
        self.containerView.addSubview(self.homeReportsView)
        self.containerView.addSubview(self.dateXLabel)
        self.containerView.addSubview(self.exitButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview()
        }
        
        self.containerView.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).priority(.low)
        }
        self.weeklyLineChart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.homeTotalView.snp.bottom).offset(6)
            make.bottom.equalTo(self.homeReportsView.snp.top).offset(-16)
        }
        self.exitButton.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.trailing.equalToSuperview().offset(-6)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(2)
        }
        
        self.bgImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.homeTotalView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(36)
        }
        
        self.homeReportsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-12)
        }
        
        self.dateXLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalTo(self.homeTotalView.snp.top).offset(-3)
        }
    }
    
    private func fetchDashData() {
        DashboardService.shared.getAllDashboardData {
            DispatchQueue.main.async {
                // Veriler yüklendi, artık dashboardData'yı alabilirsin
                self.dashboardData.removeAll()
                self.dashboardData = DashboardService.shared.getDashboardData()
                self.activeBranches = DashboardService.shared.activeBranches
                // Burada verileri kullanabilirsin, örneğin tabloyu güncelle
                if self.dashboardData.count == 0 {
                    self.homeTotalView.configure(data: ReportModels.DashboardDataModel(totalPerson: "", totalAccount: "", totalBranch: "", totalDiscount: "", grandTotal: "", xDate: ""), currency: self.currency)
                }else {
                    self.homeTotalView.configure(data: self.dashboardData[0], currency: self.getAppCurrency())
                }
                if self.dashboardData.count == 0 {
                    self.dateXLabel.text = ""
                }else {
                    self.dateXLabel.text = self.dashboardData[0].xDate
                }
            }
        }

    }
    
    private func prepareLineChart(){
        var dates: [String] = []
        var values: [Double] = []
        
        let formatla = DateFormatter()
        formatla.dateFormat = "EEEE" // "EEEE" formatı haftanın gününü tam olarak verir
        
        for data in self.lineChartData {
            
            if let date = DateFormatter.toDate(from: data.raporTarih, format: "yyyy-MM-dd'T'HH:mm:ss") {
                // Haftanın gününü elde et
                let dayOfWeek = formatla.string(from: date).translated()
                dates.append(dayOfWeek)
            } else {
                dates.append("")
            }
            values.append(data.toplam)
        }
        
        var currSymbol = ""
        switch self.currency {
        case .def:
            currSymbol = ""
        case .tl:
            currSymbol = "₺"
        case .euro:
            currSymbol = "€"
        case .usd:
            currSymbol = "$"
        }
        
        self.weeklyLineChart.setData(dates: dates, values: values,currency: currSymbol)
    }
    
    private func saveDefaultsValuesIfNeeded() {
        let defaults = UserDefaults.standard
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.savedFirmIDsKey)
        
        // Tüm firma ID'lerini kaydet
        let firmIDs = self.allFirmList.map { $0.firmaID }
        if defaults.array(forKey: Constants.UserDefaults.savedFirmIDsKey) == nil {
            defaults.set(firmIDs, forKey: Constants.UserDefaults.savedFirmIDsKey)
        }
        
        // Varsayılan tarihleri kaydet
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        if defaults.object(forKey: Constants.UserDefaults.savedStartDateKey) == nil {
            defaults.set(yesterday, forKey: Constants.UserDefaults.savedStartDateKey)
        }
        if defaults.object(forKey: Constants.UserDefaults.savedEndDateKey) == nil {
            defaults.set(today, forKey: Constants.UserDefaults.savedEndDateKey)
        }
    }
    
    private func getCurrencyCode(savedCurrency: String) -> Int {
        if savedCurrency == "USD" {
            self.currency = .usd
            return 4
        }else if savedCurrency == "TL" {
            self.currency = .tl
            return 2
        }else if savedCurrency == "EUR" {
            self.currency = .euro
            return 3
        }else { // default bu kısım
            self.currency = .def
            return 1
        }
    }
    
    private func getCommonParameters() -> (userID: String, currCode: String, startDate: String, endDate: String, firmIDs: String) {
        // Para birimi
        let savedCurr = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey) ?? "USD"
        let currCode = getCurrencyCode(savedCurrency: savedCurr as! String)
        
        // Tarihler
        let startDate = DateFormatter.string(from: UserDefaults.standard.object(forKey: Constants.UserDefaults.savedStartDateKey) as? Date ?? Date())
        let endDate = DateFormatter.string(from: UserDefaults.standard.object(forKey: Constants.UserDefaults.savedEndDateKey) as? Date ?? Date())
        
        // Şube ID'leri
        var IDs: [Int] = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedFirmIDsKey) as? [Int] ?? [-1]
        if IDs.isEmpty {
            IDs = [-1]
        }
        let firmIDs = IDs.map { String($0) }.joined(separator: ",")
        
        let userID = UserDefaults.standard.string(forKey: Constants.UserDefaults.userID) ?? ""
        
        return (userID, "\(currCode)", startDate, endDate, firmIDs)
    }
    
    // Feth Data
    
    private func getLineChartData(){
        let commonParameters = self.getCommonParameters()
        
        let today = Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? today

        let date1 = DateFormatter.string(from: today)
        let date2 = DateFormatter.string(from: oneWeekAgo)
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: date2,
                                 tarih2: date1,
                                 currCode: commonParameters.currCode)
        
        let urlString = endpoint.getUrl(for: .lineChartData)
        
        guard let url = URL(string: urlString) else {
            fatalError("Geçersiz URL")
        }
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.lineChartData = try JSONDecoder().decode([ReportModels.LineChartModel].self, from: data)
                DispatchQueue.main.async {
                    self.lineChartData.sort {$0.raporTarih < $1.raporTarih}
                    self.prepareLineChart()
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getEnCokSatanUrunler(reportType: HomeModels.TempReportTypes){
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let bestSellingUrl = endpoint.getUrl(for: .enCokSatanUrunler)
        
        guard let url = URL(string: bestSellingUrl) else {
            fatalError("Geçersiz URL")
        }
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.bestSellingProduct = try JSONDecoder().decode([ReportModels.BestSellingProductModel].self, from: data)
                DispatchQueue.main.async {
                    self.bestSellingProduct.sort {$0.tutar > $1.tutar}
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getMainGroupSalesReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let mainGroupSalesUrl = endpoint.getUrl(for: .anaGrupSatis)
        
        guard let url = URL(string: mainGroupSalesUrl) else {
            fatalError("Geçersiz URL")
        }
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.anaGrupSatis = try JSONDecoder().decode([ReportModels.MainGroupSalesReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getDiscountDetailsReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let discountDetailUrl = endpoint.getUrl(for: .indirimDetay)
        
        guard let url = URL(string: discountDetailUrl) else {
            fatalError("Geçersiz URL")
        }
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.discountDetail = try JSONDecoder().decode([ReportModels.DiscountDetailReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getPaymentDetailRaport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let paymentDetailUrl = endpoint.getUrl(for: .odemeDetay)
        
        guard let url = URL(string: paymentDetailUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.paymentDetail = try JSONDecoder().decode([ReportModels.PaymentDetailReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getFinancialReport(reportType: HomeModels.TempReportTypes)  {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let financialUrl = endpoint.getUrl(for: .gelir)
        
        guard let url = URL(string: financialUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.financial = try JSONDecoder().decode([ReportModels.FinancialReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.financial.sort {$0.toplamTutar > $1.toplamTutar}
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getPersonnelReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let personnelUrl = endpoint.getUrl(for: .personelSatis)
        
        guard let url = URL(string: personnelUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.personnel = try JSONDecoder().decode([ReportModels.PersonnelSalesReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getOpenChecksReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let openChecksUrl = endpoint.getUrl(for: .acikCekler)
        
        guard let url = URL(string: openChecksUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.openChecks = try JSONDecoder().decode([ReportModels.OpenChecksReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getUnpaidGratuityReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let unpaidGratuityUrl = endpoint.getUrl(for: .odenmezIkram)
        
        guard let url = URL(string: unpaidGratuityUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.unpaidGratuity = try JSONDecoder().decode([ReportModels.UnpaidGratuityReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getOrderTypeReport(reportType: HomeModels.TempReportTypes) {
        let commonParameters = self.getCommonParameters()
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: commonParameters.userID,
                                 firmaID: commonParameters.firmIDs,
                                 tarih1: commonParameters.startDate,
                                 tarih2: commonParameters.endDate,
                                 currCode: commonParameters.currCode)
        
        let orderTypeUrl = endpoint.getUrl(for: .siparisTipi)
        
        guard let url = URL(string: orderTypeUrl) else {
            fatalError("Geçersiz URL")
        }
        
        self.showLoader()
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                self.orderType = try JSONDecoder().decode([ReportModels.OrderTypeReportModel].self, from: data)
                DispatchQueue.main.async {
                    self.navigateToReportsDetailViewController(reportType: reportType)
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    //
    
    private func navigateToReportsDetailViewController(reportType: HomeModels.TempReportTypes){
        let destVC = ReportDetailsViewController()
        
        // reportArrays
        destVC.enCokSatanUrunler = self.bestSellingProduct
        destVC.anaGrupSatis = self.anaGrupSatis
        destVC.discountDetail = self.discountDetail
        destVC.paymentDetail = self.paymentDetail
        destVC.financial = self.financial
        destVC.personnel = self.personnel
        destVC.openCheck = self.openChecks
        destVC.unpaidGratuity = self.unpaidGratuity
        destVC.orderType = self.orderType
        //
        
        destVC.reportType = reportType
        destVC.currency = self.currency
        destVC.firmList = self.allFirmList
        destVC.firmGroupList = self.firmGroupList
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    //MARK: - Action -
    
    @objc private func exitButton_Tapped() {
        self.dashboardData.removeAll()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func refreshDashboardData() {
        self.fetchDashData()
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

    //MARK: - HomeReportsViewDelegate -

extension HomeViewController: HomeReportsViewDelegate {
    func didTappedReports(reportType: HomeModels.TempReportTypes) {
        switch reportType {
        case .gelir:
            self.getFinancialReport(reportType: reportType)
        case .enCokSatanUrunler:
            self.getEnCokSatanUrunler(reportType: reportType)
        case .siparisTipi:
            self.getOrderTypeReport(reportType: reportType)
        case .personelSatis:
            self.getPersonnelReport(reportType: reportType)
        case .acikCekler:
            self.getOpenChecksReport(reportType: reportType)
        case .anaGrupSatis:
            self.getMainGroupSalesReport(reportType: reportType)
        case .indirimDetay:
            self.getDiscountDetailsReport(reportType: reportType)
        case .odenmezIkram:
            self.getUnpaidGratuityReport(reportType: reportType)
        case .odemeDetay:
            self.getPaymentDetailRaport(reportType: reportType)
        }
    }
}

    //MARK: - HomeAllResultsViewDelegate -

extension HomeViewController: HomeAllResultsViewDelegate {
    func didTappedBranchesView() {
        let branchesVC = BranchesViewController()
        branchesVC.prepareBranchesData(allBranches: self.allFirmList, activeBranches: self.activeBranches)
        branchesVC.transitioningDelegate = self.modalPresentDelegate
        branchesVC.modalPresentationStyle = .custom
        present(branchesVC,animated: true,completion: nil)
    }
    
    func didTappedCiroView() {
        self.getFinancialReport(reportType: .gelir)
    }
    func didTappedDiscountView() {
        self.getDiscountDetailsReport(reportType: .indirimDetay)
    }
}
