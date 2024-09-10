//
//  ReportDetailsViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

class ReportDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
    }
    
    // MARK: - Public -
    var filteredStartDate: Date!
    var filteredEndDate: Date!
    
    var reportType: HomeModels.TempReportTypes = .acikCekler
    var enCokSatanUrunler: [ReportModels.BestSellingProductModel] = []
    var anaGrupSatis: [ReportModels.MainGroupSalesReportModel] = []
    var discountDetail: [ReportModels.DiscountDetailReportModel] = []
    var paymentDetail: [ReportModels.PaymentDetailReportModel] = []
    var financial: [ReportModels.FinancialReportModel] = []
    var personnel: [ReportModels.PersonnelSalesReportModel] = []
    var openCheck: [ReportModels.OpenChecksReportModel] = []
    var unpaidGratuity: [ReportModels.UnpaidGratuityReportModel] = []
    var orderType: [ReportModels.OrderTypeReportModel] = []
    
    var firmList: [HomeModels.FirmListModel] = []
    var firmGroupList: [HomeModels.FirmGroupListModel] = []
    var currency: HomeModels.Currencies = .def
    
    // MARK: - Private -
    
    private let modalPresentDelegate = ModalPresentationViewDelegate()
    
    private lazy var reportDetailsView: ReportDetailsView = {
        let view = ReportDetailsView()
        switch reportType {
        case .enCokSatanUrunler:
            if self.enCokSatanUrunler.count > 0 {
                view.sonXtarihi = self.enCokSatanUrunler[0].sonXtarihi
            }
            view.prepareBSPReport(report: self.enCokSatanUrunler, sortForBranch: true)
        case .anaGrupSatis:
            if self.anaGrupSatis.count > 0 {
                view.sonXtarihi = self.anaGrupSatis[0].sonXtarihi
            }
            view.prepareMGSReport(report: self.anaGrupSatis, sortForBranch: true)
        case .indirimDetay:
            if self.discountDetail.count > 0 {
                view.sonXtarihi = self.discountDetail[0].sonXtarihi
            }
            view.prepareDiscountReport(report: self.discountDetail, sortForBranch: true)
        case .odemeDetay:
            if self.paymentDetail.count > 0 {
                view.sonXtarihi = self.paymentDetail[0].sonXtarihi
            }
            view.preparePaymentDetailReport(report: self.paymentDetail, sortForPayment: true)
        case .gelir:
            if self.financial.count > 0 {
                view.sonXtarihi = self.financial[0].sonXtarihi
            }
            view.financial = self.financial
        case .personelSatis:
            if self.personnel.count > 0 {
                view.sonXtarihi = self.personnel[0].sonXtarihi
            }
            view.preparePersonnelSalesReport(report: self.personnel)
        case .odenmezIkram:
            if self.unpaidGratuity.count > 0 {
                view.sonXtarihi = self.unpaidGratuity[0].sonXtarihi
            }
            view.prepareUnpaidGratuity(report: self.unpaidGratuity)
        case .acikCekler:
            if self.openCheck.count > 0 {
                view.sonXtarihi = self.openCheck[0].sonXtarihi
            }
            view.prepareOpenChecksReport(report: self.openCheck)
        case .siparisTipi:
            if self.orderType.count > 0 {
                view.sonXtarihi = self.orderType[0].sonXtarihi
            }
            view.orderType = self.orderType
        }
        
        view.configure(reportType: self.reportType, curr: self.currency)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var reportChartView: ReportsChartView = {
        let view = ReportsChartView()
        let reportData = [
            ("Branch 1", 5000.0),
            ("Branch 2", 4800.0),
            ("Branch 3", 4700.0),
            ("Branch 4", 4500.0),
            ("Branch 5", 4300.0),
            ("Branch 6", 4200.0),
            ("Branch 7", 4000.0),
            ("Branch 8", 3800.0),
            ("Branch 9", 3500.0),
            ("Branch 10", 3200.0),
            ("Branch 11", 3000.0),
            ("Branch 12", 2800.0)
        ]
        view.setPieChartData(reportData: reportData)
        return view
    }()
    
    private lazy var bottomView: ReportDetailsBottomView = {
        let view = ReportDetailsBottomView()
        view.delegate = self
        return view
    }()
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(image: .loginBG)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private func prepareViews() {
        self.view.backgroundColor = .appBlue
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        
        backButton.tintColor = .systemBlue
        self.navigationItem.leftBarButtonItem = backButton
        
        // logo ekranın ortasında olabilmesi için bu atraksiyonlar . .
        let containerView = UIView()
        let omniLogo = UIImageView(image: .logoBeyazz)
        omniLogo.contentMode = .scaleAspectFill
        
        containerView.addSubview(omniLogo)
        
        omniLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            omniLogo.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            omniLogo.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            omniLogo.widthAnchor.constraint(equalToConstant: 120),
            omniLogo.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        
        self.navigationItem.titleView = containerView
        //
        
        self.filteredStartDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedStartDateKey) as? Date ?? Date()
        self.filteredEndDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedEndDateKey) as? Date ?? Date()
               
        self.view.addSubview(self.backgroundView)
        self.view.addSubview(self.reportDetailsView)
        self.view.addSubview(self.reportChartView)
        self.view.addSubview(self.bottomView)
        
        self.reportChartView.isHidden = true
        
        self.backgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.reportDetailsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        
        self.reportChartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        
        self.bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    private func getCurrencyCode(savedCurrency: String) -> Int { /// Bu kısım ortak alana yazılacak
        if savedCurrency == "USD" {
            self.currency = .usd
            return 4
        }else if savedCurrency == "TL" {
            self.currency = .tl
            return 2
        }else if savedCurrency == "EUR" {
            self.currency = .euro
            return 3
        }else {
            self.currency = .def
            return 1
        }
    }
    
    private func filteredReports(firmIDs: [Int], startDate: String, endDate: String, reportType: HomeModels.TempReportTypes){
        self.showLoader()
        
        let savedCurr = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey) ?? "USD"
        let currCode = self.getCurrencyCode(savedCurrency: savedCurr as! String)
        
        var firmIDs = firmIDs.map { String($0) }.joined(separator: ",")
        
        if firmIDs == "" {
            firmIDs = "-1"  // hiçbir şube seçilmediği zaman rapor boş gelsin diye. "" böyle olunca tüm şubeleri çekiyor
        }
        
        let serverUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedUrlKey) ?? ""
        let endpoint = Endpoints(baseURL: serverUrl,
                                 kullaniciID: "1",
                                 firmaID: firmIDs,
                                 tarih1: startDate,
                                 tarih2: endDate,
                                 currCode: "\(currCode)")
        
        var urlString: String = ""
        
        switch reportType {
        case .enCokSatanUrunler:
            urlString = endpoint.getUrl(for: .enCokSatanUrunler)
        case .anaGrupSatis:
            urlString = endpoint.getUrl(for: .anaGrupSatis)
        case .indirimDetay:
            urlString = endpoint.getUrl(for: .indirimDetay)
        case .odemeDetay:
            urlString = endpoint.getUrl(for: .odemeDetay)
        case .gelir:
            urlString = endpoint.getUrl(for: .gelir)
        case .personelSatis:
            urlString = endpoint.getUrl(for: .personelSatis)
        case .acikCekler:
            urlString = endpoint.getUrl(for: .acikCekler)
        case .odenmezIkram:
            urlString = endpoint.getUrl(for: .odenmezIkram)
        case .siparisTipi:
            urlString = endpoint.getUrl(for: .siparisTipi)
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Geçersiz URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            guard let data = data, error == nil else {
                print("İstek başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            do {
                switch reportType{
                case .anaGrupSatis:
                    self.anaGrupSatis = try JSONDecoder().decode([ReportModels.MainGroupSalesReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.anaGrupSatis.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.anaGrupSatis[0].sonXtarihi
                        }
                        self.reportDetailsView.configure(reportType: .anaGrupSatis, curr: self.currency)
                        self.reportDetailsView.prepareMGSReport(report: self.anaGrupSatis, sortForBranch: true)
                    }
                case .gelir:
                    self.financial = try JSONDecoder().decode([ReportModels.FinancialReportModel].self, from: data)
                    DispatchQueue.main.async {
                        self.financial.sort {$0.toplamTutar > $1.toplamTutar}
                        self.reportDetailsView.financial = self.financial
                        if self.financial.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.financial[0].sonXtarihi
                        }
                        self.reportDetailsView.loadTableView()
                    }
                case .indirimDetay:
                    self.discountDetail = try JSONDecoder().decode([ReportModels.DiscountDetailReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.discountDetail.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.discountDetail[0].sonXtarihi
                        }
                        self.reportDetailsView.configure(reportType: .indirimDetay, curr: self.currency)
                        self.reportDetailsView.prepareDiscountReport(report: self.discountDetail, sortForBranch: true)
                    }
                case .enCokSatanUrunler:
                    self.enCokSatanUrunler = try JSONDecoder().decode([ReportModels.BestSellingProductModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.enCokSatanUrunler.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.enCokSatanUrunler[0].sonXtarihi
                        }
                        self.reportDetailsView.configure(reportType: .enCokSatanUrunler, curr: self.currency)
                        self.reportDetailsView.prepareBSPReport(report: self.enCokSatanUrunler, sortForBranch: true)
                    }
                case .odemeDetay:
                    self.paymentDetail = try JSONDecoder().decode([ReportModels.PaymentDetailReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.paymentDetail.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.paymentDetail[0].sonXtarihi
                        }
                        self.reportDetailsView.configure(reportType: .odemeDetay, curr: self.currency)
                        self.reportDetailsView.preparePaymentDetailReport(report: self.paymentDetail, sortForPayment: true)
                    }
                case .personelSatis:
                    self.personnel = try JSONDecoder().decode([ReportModels.PersonnelSalesReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.personnel.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.personnel[0].sonXtarihi
                        }
                        self.reportDetailsView.preparePersonnelSalesReport(report: self.personnel)
                    }
                case .acikCekler:
                    self.openCheck = try JSONDecoder().decode([ReportModels.OpenChecksReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.openCheck.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.openCheck[0].sonXtarihi
                        }
                        self.reportDetailsView.prepareOpenChecksReport(report: self.openCheck)
                    }
                case .siparisTipi:
                    self.orderType = try JSONDecoder().decode([ReportModels.OrderTypeReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.orderType.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.orderType[0].sonXtarihi
                        }
                        self.reportDetailsView.orderType = self.orderType
                        self.reportDetailsView.loadTableView()
                    }
                case .odenmezIkram:
                    self.unpaidGratuity = try JSONDecoder().decode([ReportModels.UnpaidGratuityReportModel].self, from: data)
                    DispatchQueue.main.async {
                        if self.unpaidGratuity.count > 0 {
                            self.reportDetailsView.sonXtarihi = self.unpaidGratuity[0].sonXtarihi
                        }
                        self.reportDetailsView.prepareUnpaidGratuity(report: self.unpaidGratuity)
                    }
                }
                
            } catch {
                print("JSON decode işlemi başarısız: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    //MARK: - Action -
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

    //MARK: -ReportDetailsBottomViewDelegate -

extension ReportDetailsViewController: ReportDetailsBottomViewDelegate {
    func didTappedButton(buttonType: ReportDetails.BottomButtonTypes) {
        switch buttonType {
        case .home:
            self.navigationController?.popViewController(animated: true)
        case .report:
            self.reportDetailsView.changeDisplayType()
        case .filter:
            let destinationVC = FilterViewController()
            destinationVC.firmList = self.firmList
            destinationVC.firmGroupList = self.firmGroupList
            destinationVC.selectedStartDate = self.filteredStartDate
            destinationVC.selectedEndDate = self.filteredEndDate
            destinationVC.reportType = self.reportType
            
            destinationVC.onFilterApply = { [weak self] firmIDs, startDate, endDate , reportType in
                guard let self = self else { return }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                      
                if let startDate = formatter.date(from: startDate) {
                    self.filteredStartDate = startDate
                }
                
                if let endDate = formatter.date(from: endDate) {
                    self.filteredEndDate = endDate
                }
                
                self.filteredReports(firmIDs: firmIDs, startDate: startDate, endDate: endDate,reportType: reportType)
            }
            
            destinationVC.transitioningDelegate = self.modalPresentDelegate
            destinationVC.modalPresentationStyle = .custom
            present(destinationVC,animated: true,completion: nil)
            
        }
    }
}
