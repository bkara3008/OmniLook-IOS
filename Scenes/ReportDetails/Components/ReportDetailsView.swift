//
//  ReportDetailsView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

class ReportDetailsView: UIView {
    //MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(reportType: HomeModels.TempReportTypes, curr: HomeModels.Currencies){
        self.reportType = reportType
        self.currency = curr
        var localizedText = ""
        
        let selectedHeaderView: UIView
        
        switch reportType {
        case .gelir:
            localizedText = "Financial_Report".translated()
            selectedHeaderView = FinancialHeaderView()
        case .enCokSatanUrunler:
            localizedText = "Best_Selling_Products_report".translated()
            let bestSelling = BestSellingProducttHeaderView()
            bestSelling.delegate = self
            bestSelling.updateLabelsForSorting(isBranch: true)
            selectedHeaderView = bestSelling
        case .siparisTipi:
            localizedText = "Order_Type_Report".translated()
            selectedHeaderView = OrderTypeHeaderView()
        case .personelSatis:
            localizedText = "Personnel_Sales_Report".translated()
            selectedHeaderView = PersonnelSalesHeaderView()
        case .acikCekler:
            localizedText = "Open_Checks_Report".translated()
            selectedHeaderView = OpenChecksHeaderView()
        case .anaGrupSatis:
            localizedText = "Main_Group_Sales_Report".translated()
            let mainGroup = MainGroupSalesHeaderView()
            mainGroup.delegate = self
            mainGroup.updateLabelsForSorting(isBranch: true)
            selectedHeaderView = mainGroup
        case .indirimDetay:
            localizedText = "Discount_Detail_Report".translated()
            let discountDetail = DiscountDetailHeaderView()
            discountDetail.delegate = self
            discountDetail.updateLabelsForSorting(isBranch: true)
            selectedHeaderView = discountDetail
        case .odenmezIkram:
            localizedText = "Unpaid_Gratuity_Report".translated()
            selectedHeaderView = UnpaidGratuityHeaderView()
        case .odemeDetay:
            localizedText = "Payment_Detail_Report".translated()
            let paymentDetail = PaymentDetailHeaderView()
            paymentDetail.delegate = self
            paymentDetail.updateLabelsForSorting(isPayment: true)
            selectedHeaderView = paymentDetail
        }
        
        self.ReportNameLabel.text = localizedText.translated()
        
        selectedHeaderView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        self.startDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedStartDateKey) as? Date ?? Date()
        self.endDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedEndDateKey) as? Date ?? Date()
        
        if self.sonXtarihi != "" {
            let xDate = DateFormatter.toDate(from: self.sonXtarihi, format: "yyyy-MM-dd'T'HH:mm:ss")
            let endDateString: String
            
            if Calendar.current.isDateInToday(self.endDate ?? Date()) {
                endDateString = DateFormatter.longStringDate(from: xDate ?? Date(), format: "dd.MM.yyyy HH:mm")
            } else {
                endDateString = DateFormatter.string(from: self.endDate ?? Date())
            }
            
            let startDateString = DateFormatter.string(from: self.startDate ?? Date())
            
            self.reportDateView.configure(startDate: startDateString,
                                              endDate: endDateString)
        }else {
            self.reportDateView.configure(startDate: DateFormatter.string(from: startDate ?? Date()),
                                              endDate: DateFormatter.string(from: endDate ?? Date()))
        }
        
        // Bu kısımda filtereleme sonucu var olan headerView'ın altına aynısı tekrardan eklemesin diye var olanı siliyoruz. .
        for subview in self.containerStackView.arrangedSubviews {
            if type(of: subview) == type(of: selectedHeaderView) {
                self.containerStackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        }
        
        self.containerStackView.insertArrangedSubview(selectedHeaderView, at: 1)
        self.tableView.reloadData()
    }

    func changeDisplayType() {
        if self.displayType == .list {
            self.displayType = .pieChart
        }else {
            self.displayType = .list
        }
        
        switch self.displayType {
        case .pieChart:
            self.tableView.isHidden = true
            self.pieChartView.isHidden = false
            self.updateStackViewSubviewVisibility(at: 1, shouldShow: false)
            self.preparePieChartData()
        case .list:
            self.tableView.isHidden = false
            self.pieChartView.isHidden = true
            self.updateStackViewSubviewVisibility(at: 1, shouldShow: true)
        }
    }
    
    // MARK: - Public -
    var displayType: ReportDetails.DisplayTypes = .list

    var sonXtarihi: String = ""
    
    var enCokSatanUrunler: [ReportModels.BestSellingProductModel] = []
    var anaGrupSatis: [ReportModels.MainGroupSalesReportModel] = []
    var financial: [ReportModels.FinancialReportModel] = []
    var personnel: [ReportModels.PersonnelSalesReportModel] = []
    var openChecks: [ReportModels.OpenChecksReportModel] = []
    var orderType: [ReportModels.OrderTypeReportModel] = []
    var paymentDetail: [ReportModels.PaymentDetailReportModel] = []
    var discountDetail: [ReportModels.DiscountDetailReportModel] = []
    var unpaidGratuity: [ReportModels.UnpaidGratuityReportModel] = []

    var groupedMGSReport: [ReportModels.MGSRGroupedModel] = []
    var groupedDiscountDetails: [ReportModels.DDRGroupedModel] = []
    var groupedPaymentDetail: [ReportModels.PDRGroupedModel] = []
    var groupedUnpaidGratuity: [ReportModels.UGRGroupedModel] = []
    var groupedOpenChecks: [ReportModels.OCRGroupedModel] = []
    var groupedPersonnel: [ReportModels.PSRGroupedModel] = []
    var groupedEnCokSatan: [ReportModels.BSPRGroupedModel] = []
    
    // MARK: - Private -
    
    private var startDate: Date?
    private var endDate: Date?
    private var currency: HomeModels.Currencies = .def
    private var reportType: HomeModels.TempReportTypes?
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.ReportNameLabel,
                                                       self.tableView,
                                                       self.pieChartView,
                                                       self.reportDateView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var ReportNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var reportDateView: ReportsDateView = {
        let view = ReportsDateView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        return view
    }()
    
    private lazy var pieChartView: ReportsChartView = {
        let view = ReportsChartView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cell Register
        tableView.register(BestSellingProductCell.self,
                           forCellReuseIdentifier: BestSellingProductCell.identifier)
        tableView.register(DiscountDetailsCell.self,
                           forCellReuseIdentifier: DiscountDetailsCell.identifier)
        tableView.register(MainGroupSalesCell.self,
                           forCellReuseIdentifier: MainGroupSalesCell.identifier)
        tableView.register(PaymentDetailCell.self,
                           forCellReuseIdentifier: PaymentDetailCell.identifier)
        tableView.register(FinancialCell.self,
                           forCellReuseIdentifier: FinancialCell.identifier)
        tableView.register(PersonnelCell.self,
                           forCellReuseIdentifier: PersonnelCell.identifier)
        tableView.register(OpenChecksCell.self,
                           forCellReuseIdentifier: OpenChecksCell.identifier)
        tableView.register(UnpaidGratuityCell.self,
                           forCellReuseIdentifier: UnpaidGratuityCell.identifier)
        tableView.register(OrderTypeCell.self,
                           forCellReuseIdentifier: OrderTypeCell.identifier)
        tableView.register(FinancialTotalCell.self,
                           forCellReuseIdentifier: FinancialTotalCell.identifier)
        tableView.register(OrderTypeTotalCell.self,
                           forCellReuseIdentifier: OrderTypeTotalCell.identifier)
        
        
        // Section Register
        tableView.register(MainGroupSalesSectionView.self,
                           forHeaderFooterViewReuseIdentifier: MainGroupSalesSectionView.identifier)
        tableView.register(DiscountDetailsSectionView.self,
                           forHeaderFooterViewReuseIdentifier: DiscountDetailsSectionView.identifier)
        tableView.register(PaymentDetailSectionView.self,
                           forHeaderFooterViewReuseIdentifier: PaymentDetailSectionView.identifier)
        tableView.register(UnpaidGratuitySectionView.self,
                           forHeaderFooterViewReuseIdentifier: UnpaidGratuitySectionView.identifier)
        tableView.register(PersonnelSalesSectionView.self,
                           forHeaderFooterViewReuseIdentifier: PersonnelSalesSectionView.identifier)
        tableView.register(BestSellingProductSectionView.self,
                           forHeaderFooterViewReuseIdentifier: BestSellingProductSectionView.identifier)
        
        // Footer Register
        tableView.register(PersonnelSalesFooterView.self,
                           forHeaderFooterViewReuseIdentifier: PersonnelSalesFooterView.identifier)
        tableView.register(CommonReportsFooterView.self,
                           forHeaderFooterViewReuseIdentifier: CommonReportsFooterView.identifier)
        tableView.register(PaymentDetailFooterView.self,
                           forHeaderFooterViewReuseIdentifier: PaymentDetailFooterView.identifier)
        tableView.register(BestSellingProductFooterView.self,
                           forHeaderFooterViewReuseIdentifier: BestSellingProductFooterView.identifier)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        return tableView
    }()
    
    private func commonInit() {
        self.addSubview(self.containerStackView)
        
        switch self.displayType {
        case .pieChart:
            self.pieChartView.isHidden = false
            self.tableView.isHidden = true
        case .list:
            self.pieChartView.isHidden = true
            self.tableView.isHidden = false
        }
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        self.ReportNameLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        self.reportDateView.snp.makeConstraints { make in
            make.height.equalTo(26)
        }
        
        self.tableView.reloadData()
    }
    
    private func preparePieChartData() {
        let reportData = self.getPieChartData(reportType: self.reportType ?? .gelir)
        self.pieChartView.setPieChartData(reportData: reportData)
    }
    
    func getPieChartData(reportType: HomeModels.TempReportTypes) -> [(String, Double)] {
        
        var reportData: [(String, Double)] = []
        
        switch reportType {
        case .gelir:
            for data in self.financial {
                let branch = data.subeAdi
                let revenue = data.toplamTutar
                reportData.append((branch, revenue))
            }
        case .personelSatis:
            // Kasiyer adlarına göre gruplama yapıyoruz
            var personnelDict: [String: Double] = [:]
            
            for data in self.personnel {
                let branch = data.kasiyerAdi
                let revenue = data.toplamTutar
                
                // Eğer aynı kasiyer adı varsa toplam tutarı ekliyoruz, yoksa yeni bir giriş yapıyoruz
                if let existingRevenue = personnelDict[branch] {
                    personnelDict[branch] = existingRevenue + revenue
                } else {
                    personnelDict[branch] = revenue
                }
            }
            
            // Gruplandırılmış verileri reportData array'ine ekliyoruz
            for (kasiyerAdi, toplamTutar) in personnelDict {
                reportData.append((kasiyerAdi, toplamTutar))
            }
        case .enCokSatanUrunler:
            for data in self.enCokSatanUrunler {
                let branch = data.urunAdi
                let revenue = data.tutar
                reportData.append((branch, revenue))
            }
        case .indirimDetay:
            // indirim  adlarına göre gruplama yapıyoruz
            var discountDict: [String: Double] = [:]
            
            for data in self.discountDetail {
                let branch = data.indirimAdi
                let revenue = data.indirimTutari
                
                // Eğer aynı indirim adı varsa toplam tutarı ekliyoruz, yoksa yeni bir giriş yapıyoruz
                if let existingRevenue = discountDict[branch] {
                    discountDict[branch] = existingRevenue + revenue
                } else {
                    discountDict[branch] = revenue
                }
            }
            
            // Gruplandırılmış verileri reportData array'ine ekliyoruz
            for (indirimAdi, toplamTutar) in discountDict {
                reportData.append((indirimAdi, toplamTutar))
            }
        case .siparisTipi:
            for data in self.orderType {
                let branch = data.satisTuru
                let revenue = data.tutar
                reportData.append((branch, revenue))
            }
        case .acikCekler:
            for data in self.openChecks {
                let branch = data.subeAdi
                let revenue = data.toplamTutar
                reportData.append((branch, revenue))
            }
        case .anaGrupSatis:
            // ana grup  adlarına göre gruplama yapıyoruz
            var mainGroupSalesDict: [String: Double] = [:]
            
            for data in self.anaGrupSatis {
                let branch = data.anaGrupAdi
                let revenue = data.fiyat
                
                // Eğer aynı indirim adı varsa toplam tutarı ekliyoruz, yoksa yeni bir giriş yapıyoruz
                if let existingRevenue = mainGroupSalesDict[branch] {
                    mainGroupSalesDict[branch] = existingRevenue + revenue
                } else {
                    mainGroupSalesDict[branch] = revenue
                }
            }
            
            // Gruplandırılmış verileri reportData array'ine ekliyoruz
            for (anaGrupAdi, toplamTutar) in mainGroupSalesDict {
                reportData.append((anaGrupAdi, toplamTutar))
            }
        case .odenmezIkram:
            // şube adlarına göre gruplama yapıyoruz
            var unpaidDict: [String: Double] = [:]
            
            for data in self.unpaidGratuity {
                let branch = data.indirimAdi
                let revenue = data.tutar
                
                // Eğer aynı indirim adı varsa toplam tutarı ekliyoruz, yoksa yeni bir giriş yapıyoruz
                if let existingRevenue = unpaidDict[branch] {
                    unpaidDict[branch] = existingRevenue + revenue
                } else {
                    unpaidDict[branch] = revenue
                }
            }
            
            // Gruplandırılmış verileri reportData array'ine ekliyoruz
            for (sube, toplamTutar) in unpaidDict {
                reportData.append((sube, toplamTutar))
            }
        case .odemeDetay:
            // odemeTipine göre gruplama yapıyoruz
            var paymentDict: [String: Double] = [:]
            
            for data in self.paymentDetail {
                let branch = data.odemeAdi
                let revenue = data.toplam
                
                // Eğer aynı indirim tipi varsa toplam tutarı ekliyoruz, yoksa yeni bir giriş yapıyoruz
                if let existingRevenue = paymentDict[branch] {
                    paymentDict[branch] = existingRevenue + revenue
                } else {
                    paymentDict[branch] = revenue
                }
            }
            
            // Gruplandırılmış verileri reportData array'ine ekliyoruz
            for (indirimAdi, toplamTutar) in paymentDict {
                reportData.append((indirimAdi, toplamTutar))
            }
        }
        
        // Eğer toplam veri yoksa boş array döndür
        guard reportData.count > 0 else {
            print("Hata: Veriler boş.")
            return []
        }
        
        // Verileri sıralayıp en yüksek 10 şubeyi alıyoruz
        let sortedData = reportData.sorted(by: { $0.1 > $1.1 })
        
        // Toplam geliri hesaplıyoruz
        let totalRevenue = sortedData.reduce(0) { $0 + $1.1 }
        
        // Eğer toplam veri sayısı 10'dan az ise tüm verileri alıyoruz ve oranları hesaplıyoruz
        if sortedData.count <= 10 {
            return sortedData.map { (branch, revenue) in
                let percentage = (revenue / totalRevenue) * 100
                return (branch, percentage)
            }
        }
        
        // İlk 10 şubeyi al
        let topTenBranches = sortedData.prefix(10)
        
        // Kalan diğer şubelerin toplamını hesaplıyoruz
        let otherBranchesSum = sortedData.suffix(from: 10).reduce(0) { $0 + $1.1 }
        
        // Top 10 şubeyi rapora ekliyoruz ve oranlarını hesaplıyoruz
        var finalReportData: [(String, Double)] = topTenBranches.map { (branch, revenue) in
            let percentage = (revenue / totalRevenue) * 100
            return (branch, percentage)
        }
        
        // Diğer şubeleri "Other" olarak ekliyoruz, yalnızca eğer 10'dan fazla veri varsa
        if sortedData.count > 10 && otherBranchesSum > 0 {
            let otherPercentage = (otherBranchesSum / totalRevenue) * 100
            finalReportData.append(("Other".translated(), otherPercentage))
        }
        
        return finalReportData
    }
    
    // UIStackView'ın 1. indexindeki view'in isHidden'ını değiştirmek için bir fonksiyon
    func updateStackViewSubviewVisibility(at index: Int, shouldShow: Bool) {
        // UIStackView'deki alt view'in var olup olmadığını kontrol ediyoruz
        guard index < containerStackView.arrangedSubviews.count else {
            print("Index out of bounds")
            return
        }
        
        // Belirtilen index'teki view'in isHidden özelliğini ayarlıyoruz
        containerStackView.arrangedSubviews[index].isHidden = !shouldShow
    }
    
    // Prepare Report Data
    func prepareBSPReport(report: [ReportModels.BestSellingProductModel], sortForBranch: Bool) {
        self.enCokSatanUrunler = report
        if sortForBranch {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
            
            self.groupedEnCokSatan = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.tutar }
                let totalbranch = value.reduce(0) {$0 + $1.miktar}
                return ReportModels.BSPRGroupedModel(title: key, items: value,totalAmount: totalAmount, totalQuantity: totalbranch, isExpanded: false, isSortForProduct: false)
            }
            
            self.groupedEnCokSatan.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<groupedEnCokSatan.count {
                groupedEnCokSatan[index].items.sort { $0.tutar > $1.tutar }
            }
        }else {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.urunAdi })
            
            self.groupedEnCokSatan = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.tutar }
                let totalbranch = value.reduce(0) {$0 + $1.miktar}
                return ReportModels.BSPRGroupedModel(title: key, items: value,totalAmount: totalAmount, totalQuantity: totalbranch, isExpanded: false, isSortForProduct: true)
            }
            
            self.groupedEnCokSatan.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<groupedEnCokSatan.count {
                groupedEnCokSatan[index].items.sort { $0.tutar > $1.tutar }
            }
        }
        
        if self.groupedEnCokSatan.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        self.loadTableView()
    }
    
    func prepareMGSReport(report: [ReportModels.MainGroupSalesReportModel], sortForBranch: Bool) {
        self.anaGrupSatis = report
        
        if sortForBranch {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
            
            self.groupedMGSReport = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.fiyat }
                let totalbranch = value.count
                return ReportModels.MGSRGroupedModel(title: key, items: value, totalAmount: totalAmount, totalBranch: totalbranch, isExpanded: false, isSortForBranch: true)
            }
            
            self.groupedMGSReport.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<self.groupedMGSReport.count {
                self.groupedMGSReport[index].items.sort{ $0.fiyat > $1.fiyat }
            }
        }else {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.anaGrupAdi })
            
            self.groupedMGSReport = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.fiyat }
                let totalbranch = value.count
                return ReportModels.MGSRGroupedModel(title: key, items: value, totalAmount: totalAmount, totalBranch: totalbranch, isExpanded: false, isSortForBranch: false)
            }
            
            self.groupedMGSReport.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<self.groupedMGSReport.count {
                self.groupedMGSReport[index].items.sort { $0.fiyat > $1.fiyat }
            }
        }
        
        if self.groupedMGSReport.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    
    func prepareDiscountReport(report: [ReportModels.DiscountDetailReportModel], sortForBranch: Bool) {
        self.discountDetail = report
        
        if sortForBranch {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
            
            self.groupedDiscountDetails = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.indirimTutari }
                let totalChecks = value.count
                return ReportModels.DDRGroupedModel(title: key, items: value, discountAmount: totalAmount, totalChecks: totalChecks, isExpanded: false, isSortForProduct: true)
            }
            
            self.groupedDiscountDetails.sort { $0.discountAmount > $1.discountAmount }
            for index in 0..<groupedDiscountDetails.count {
                groupedDiscountDetails[index].items.sort { $0.indirimTutari > $1.indirimTutari }
            }
        }else {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.indirimAdi })
            
            self.groupedDiscountDetails = groupedDictionary.map { key, value in
                let totalAmount = value.reduce(0) { $0 + $1.indirimTutari }
                let totalChecks = value.count
                return ReportModels.DDRGroupedModel(title: key, items: value, discountAmount: totalAmount, totalChecks: totalChecks, isExpanded: false, isSortForProduct: false)
            }
            
            self.groupedDiscountDetails.sort { $0.discountAmount > $1.discountAmount }
            for index in 0..<groupedDiscountDetails.count {
                groupedDiscountDetails[index].items.sort { $0.indirimTutari > $1.indirimTutari }
            }
        }
        
        if self.groupedDiscountDetails.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    
    func preparePaymentDetailReport(report: [ReportModels.PaymentDetailReportModel], sortForPayment: Bool) {
        self.paymentDetail = report
        
        if sortForPayment {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.odemeAdi })
            
            self.groupedPaymentDetail = groupedDictionary.map { key, value in
                let totalAccount = value.reduce(0) { $0 + $1.hesapSayisi }
                let totalAmount = value.reduce(0) {$0 + $1.toplam}
                return ReportModels.PDRGroupedModel(title: key, items: value, totalAmount: totalAmount, totalAccount: totalAccount, isExpanded: false, isSortForPayment: true)
            }
            
            self.groupedPaymentDetail.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<self.groupedPaymentDetail.count {
                self.groupedPaymentDetail[index].items.sort{ $0.toplam > $1.toplam }
            }
        }else {
            let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
            
            self.groupedPaymentDetail = groupedDictionary.map { key, value in
                let totalAccount = value.reduce(0) { $0 + $1.hesapSayisi }
                let totalAmount = value.reduce(0) {$0 + $1.toplam}
                return ReportModels.PDRGroupedModel(title: key, items: value, totalAmount: totalAmount, totalAccount: totalAccount, isExpanded: false, isSortForPayment: false)
            }
            
            self.groupedPaymentDetail.sort { $0.totalAmount > $1.totalAmount }
            for index in 0..<self.groupedPaymentDetail.count {
                self.groupedPaymentDetail[index].items.sort { $0.toplam > $1.toplam }
            }
        }
        
        if self.groupedPaymentDetail.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    
    func prepareUnpaidGratuity(report: [ReportModels.UnpaidGratuityReportModel]) {
        self.unpaidGratuity = report
        let groupedDictionary = Dictionary(grouping: report, by: { $0.indirimAdi })
        
        self.groupedUnpaidGratuity = groupedDictionary.map { key, value in
            let totalAmount = value.reduce(0) { $0 + $1.tutar }
            return ReportModels.UGRGroupedModel(title: key, items: value, totalAmount: totalAmount, isExpanded: false)
        }
        self.groupedUnpaidGratuity.sort { $0.totalAmount > $1.totalAmount }
        for index in 0..<groupedUnpaidGratuity.count {
            groupedUnpaidGratuity[index].items.sort { $0.tutar > $1.tutar }
        }

        if self.groupedUnpaidGratuity.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    
    func prepareOpenChecksReport(report: [ReportModels.OpenChecksReportModel]) {
        self.openChecks = report
        let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
        
        self.groupedOpenChecks = groupedDictionary.map { key, value in
            let totalAmount = value.reduce(0) { $0 + $1.toplamTutar }
            return ReportModels.OCRGroupedModel(title: key, items: value, totalAmount: totalAmount, isExpanded: false)
        }
        self.groupedOpenChecks.sort { $0.totalAmount > $1.totalAmount }
        for index in 0..<groupedOpenChecks.count {
            groupedOpenChecks[index].items.sort { $0.toplamTutar > $1.toplamTutar }
        }
        
        if self.groupedOpenChecks.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    
    func preparePersonnelSalesReport(report: [ReportModels.PersonnelSalesReportModel]) {
        self.personnel = report
        let groupedDictionary = Dictionary(grouping: report, by: { $0.subeAdi })
        
        self.groupedPersonnel = groupedDictionary.map { key, value in
            let totalAmount = value.reduce(0) { $0 + $1.toplamTutar }
            let totalPerson = value.reduce(0) { $0 + $1.kisiSayisi }
            let totalAccount = value.reduce(0) { $0 + $1.hesapSayisi }
            
            return ReportModels.PSRGroupedModel(title: key, items: value, totalPerson: Int(totalPerson), totalAccount: Int(totalAccount), totalAmount: totalAmount, isExpanded: false)
        }
        
        self.groupedPersonnel.sort { $0.totalAmount > $1.totalAmount }
        for index in 0..<groupedPersonnel.count {
            groupedPersonnel[index].items.sort { $0.toplamTutar > $1.toplamTutar }
        }
        
        if self.groupedPersonnel.count < 1 {
            showAlert(message: "No_Report_Data".translated())
        }
        
        self.loadTableView()
    }
    //
    
    func loadTableView() { // silme !
        
        self.startDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedStartDateKey) as? Date ?? Date()
        self.endDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedEndDateKey) as? Date ?? Date()
        
        // Rapor ekranında tarih bugün ise endDate'i ayarlar . .
        if self.sonXtarihi != "" {
            let xDate = DateFormatter.toDate(from: self.sonXtarihi, format: "yyyy-MM-dd'T'HH:mm:ss")
            let endDateString: String
            
            if Calendar.current.isDateInToday(self.endDate ?? Date()) {
                endDateString = DateFormatter.longStringDate(from: xDate ?? Date(), format: "dd.MM.yyyy HH:mm")
            } else {
                endDateString = DateFormatter.string(from: self.endDate ?? Date())
            }
            
            let startDateString = DateFormatter.string(from: self.startDate ?? Date())
            
            self.reportDateView.configure(startDate: startDateString,
                                              endDate: endDateString)
        }else {
            self.reportDateView.configure(startDate: DateFormatter.string(from: startDate ?? Date()),
                                              endDate: DateFormatter.string(from: endDate ?? Date()))
        }
        
        switch self.displayType {
        case .pieChart:
            self.pieChartView.isHidden = false
            self.tableView.isHidden = true
            self.updateStackViewSubviewVisibility(at: 1, shouldShow: false)
        case .list:
            self.pieChartView.isHidden = true
            self.tableView.isHidden = false
            self.updateStackViewSubviewVisibility(at: 1, shouldShow: true)
        }
        
        self.preparePieChartData()
        self.tableView.reloadData()

    }
}

    //MARK: - UITableViewDelegate -
extension ReportDetailsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch self.reportType {
        case .personelSatis:
            return section == groupedPersonnel.count - 1 ? 40 : 0
        case .acikCekler:
            return section == groupedOpenChecks.count - 1 ? 40 : 0
        case .indirimDetay:
            return section == groupedDiscountDetails.count - 1 ? 40 : 0
        case .odenmezIkram:
            return section == groupedUnpaidGratuity.count - 1 ? 40 : 0
        case .anaGrupSatis:
            return section == groupedMGSReport.count - 1 ? 40 : 0
        case .odemeDetay:
            return section == groupedPaymentDetail.count - 1 ? 40 : 0
        case .enCokSatanUrunler:
            return section == groupedEnCokSatan.count - 1 ? 40 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.reportType {
        case .indirimDetay, .odemeDetay, .anaGrupSatis, .odenmezIkram, .acikCekler, .personelSatis, .enCokSatanUrunler:
            return 40
        default:
            return 0
        }
    }
}

    //MARK: - UITableViewDataSource -
extension ReportDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.reportType {
        case .indirimDetay:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscountDetailsCell.identifier, for: indexPath) as? DiscountDetailsCell  else {
                return UITableViewCell()
            }
            let reportItem = self.groupedDiscountDetails[indexPath.section].items[indexPath.row]
            let isBranch = self.groupedDiscountDetails[indexPath.section].isSortForProduct
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency, isBranch: isBranch)
            return cell
        case .odenmezIkram:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnpaidGratuityCell.identifier, for: indexPath) as? UnpaidGratuityCell  else {
                return UITableViewCell()
            }
            let reportItem = self.groupedUnpaidGratuity[indexPath.section].items[indexPath.row]
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency)
            return cell
            
        case.enCokSatanUrunler:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BestSellingProductCell.identifier, for: indexPath) as? BestSellingProductCell  else {
                return UITableViewCell()
            }
            let reportItem = self.groupedEnCokSatan[indexPath.section].items[indexPath.row]
            let isProduct = self.groupedEnCokSatan[indexPath.section].isSortForProduct
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency, isProduct: isProduct)
            return cell
            
        case .acikCekler:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OpenChecksCell.identifier, for: indexPath) as? OpenChecksCell  else {
                return UITableViewCell()
            }
            let reportItem = self.groupedOpenChecks[indexPath.section].items[indexPath.row]
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency)
            return cell
            
        case.anaGrupSatis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainGroupSalesCell.identifier, for: indexPath) as? MainGroupSalesCell  else {
                return UITableViewCell()
            }
            
            let reportItem = self.groupedMGSReport[indexPath.section].items[indexPath.row]
            let isBranch = self.groupedMGSReport[indexPath.section].isSortForBranch
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency, sortForBranch: isBranch)
            return cell
            
        case .odemeDetay:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentDetailCell.identifier, for: indexPath) as? PaymentDetailCell  else {
                return UITableViewCell()
            }
            
            let reportItem = self.groupedPaymentDetail[indexPath.section].items[indexPath.row]
            let isPayment = self.groupedPaymentDetail[indexPath.section].isSortForPayment
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency, sortForPayment: isPayment)
            return cell
        case .gelir:
            
            if indexPath.row == self.financial.count { //  Toplam CELL . .
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FinancialTotalCell.identifier, for: indexPath) as? FinancialTotalCell  else {
                    return UITableViewCell()
                }
                let totalPerson = "\(self.financial.reduce(0) {$0 + $1.kisiSayisi})"
                let totalAmount = "\(self.financial.reduce(0) {$0 + $1.toplamTutar}.formatCurrency(currency: self.currency))"
                let openCheckNumber = "\(self.financial.reduce(0) {$0 + $1.acikCekAdedi})"
                let openCheckAmount = "\(self.financial.reduce(0) {$0 + $1.acikCekTutari}.formatCurrency(currency: self.currency))"
                
                cell.configure(personTitle: totalPerson, totalAmount: totalAmount, openCheckNumber: openCheckNumber, openCheckAmount: openCheckAmount)
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FinancialCell.identifier, for: indexPath) as? FinancialCell  else {
                return UITableViewCell()
            }
            let item = self.financial[indexPath.row]
            cell.setupCell(item: item, index: indexPath.row, curr: self.currency)
            return cell
        case .personelSatis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonnelCell.identifier, for: indexPath) as? PersonnelCell  else {
                return UITableViewCell()
            }
            let reportItem = self.groupedPersonnel[indexPath.section].items[indexPath.row]
            cell.setupCell(item: reportItem, index: indexPath.row, curr: self.currency)
            return cell
        case .siparisTipi:
            if indexPath.row == self.orderType.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTypeTotalCell.identifier, for: indexPath) as? OrderTypeTotalCell  else {
                    return UITableViewCell()
                }
                let totalPerson = "\(self.orderType.reduce(0) {$0 + $1.kisiSayisi})"
                let totalAccount = "\(self.orderType.reduce(0) {$0 + $1.hesapSayisi})"
                let totalAmount = "\(self.orderType.reduce(0) {$0 + $1.tutar}.formatCurrency(currency: self.currency))"
                
                cell.setupCell(totalPerson: totalPerson, totalAccount: totalAccount, totalAmount: totalAmount)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTypeCell.identifier, for: indexPath) as? OrderTypeCell  else {
                return UITableViewCell()
            }
            let item = self.orderType[indexPath.row]
            cell.setupCell(item: item, index: indexPath.row, curr: self.currency)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.reportType{
        case .indirimDetay:
            if self.groupedDiscountDetails.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.groupedDiscountDetails[section].isExpanded ? self.groupedDiscountDetails[section].items.count : 0
            }
        case .odenmezIkram:
            if self.groupedUnpaidGratuity.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.groupedUnpaidGratuity[section].isExpanded ? self.groupedUnpaidGratuity[section].items.count : 0
            }
        case .personelSatis:
            if self.groupedPersonnel.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.groupedPersonnel[section].isExpanded ? groupedPersonnel[section].items.count : 0
            }
        case .acikCekler:
            if self.groupedOpenChecks.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else{
                return self.groupedOpenChecks[section].isExpanded ? groupedOpenChecks[section].items.count : 0
            }
        case .siparisTipi:
            if self.orderType.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.orderType.count + 1
            }
        case .enCokSatanUrunler:
            if self.groupedEnCokSatan.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.groupedEnCokSatan[section].isExpanded ? groupedEnCokSatan[section].items.count : 0
            }
        case .anaGrupSatis:
            if self.groupedMGSReport.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else{
                return self.groupedMGSReport[section].isExpanded ? groupedMGSReport[section].items.count : 0
            }
        case .odemeDetay:
            if self.groupedPaymentDetail.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else{
                return self.groupedPaymentDetail[section].isExpanded ? self.groupedPaymentDetail[section].items.count : 0
            }
        case .gelir:
            if self.financial.isEmpty {
                showAlert(message: "No_Report_Data".translated())
                return 0
            }else {
                return self.financial.count + 1
            }
        case .none:
            return 0
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".translated(), style: .default, handler: nil))
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch self.reportType{
        case .anaGrupSatis:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainGroupSalesSectionView.identifier) as? MainGroupSalesSectionView else {
                return nil
            }
            
            let group = self.groupedMGSReport[section]
            headerView.configure(title: group.title,
                                 totalBranch: "\(group.totalBranch)",
                                 amount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedMGSReport[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
            
        case .indirimDetay:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiscountDetailsSectionView.identifier) as? DiscountDetailsSectionView else {
                return nil
            }
            
            let group = self.groupedDiscountDetails[section]
            headerView.configure(title: group.title,
                                 amount: group.discountAmount.formatCurrency(currency: self.currency),
                                 totalCheck: "\(group.totalChecks)",
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedDiscountDetails[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        case .acikCekler: // Başka bir header ile deneme
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UnpaidGratuitySectionView.identifier) as? UnpaidGratuitySectionView else {
                return nil
            }
            
            let group = self.groupedOpenChecks[section]
            headerView.configure(title: group.title,
                                 amount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedOpenChecks[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        case .odemeDetay:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PaymentDetailSectionView.identifier) as? PaymentDetailSectionView else {
                return nil
            }
            
            let group = self.groupedPaymentDetail[section]
            headerView.configure(title: group.title,
                                 totalAccount: "\(group.totalAccount)",
                                 amount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedPaymentDetail[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        case .odenmezIkram:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UnpaidGratuitySectionView.identifier) as? UnpaidGratuitySectionView else {
                return nil
            }
            
            let group = self.groupedUnpaidGratuity[section]
            headerView.configure(title: group.title,
                                 amount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedUnpaidGratuity[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        case .personelSatis:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonnelSalesSectionView.identifier) as? PersonnelSalesSectionView else {
                return nil
            }
            
            let group = self.groupedPersonnel[section]
            headerView.configure(title: group.title,
                                 totalPerson: "\(group.totalPerson)",
                                 totalAccount: "\(group.totalAccount)",
                                 totalAmount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedPersonnel[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        case .enCokSatanUrunler:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BestSellingProductSectionView.identifier) as? BestSellingProductSectionView else {
                return nil
            }
            
            let group = self.groupedEnCokSatan[section]
            headerView.configure(branchOrProduct: group.title,
                                 product: "\(Int(group.totalQuantity))",
                                 amount: group.totalAmount.formatCurrency(currency: self.currency),
                                 isExpand: group.isExpanded)
            
            headerView.onExpandButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.groupedEnCokSatan[section].isExpanded.toggle()
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
            
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch self.reportType{
        case .personelSatis:
            if section == self.groupedPersonnel.count - 1 {
                guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonnelSalesFooterView.identifier) as? PersonnelSalesFooterView else {
                    return nil
                }
                
                let totalPerson = "\(self.groupedPersonnel.reduce(0) {$0 + $1.totalPerson})"
                let totalAccount = "\(self.groupedPersonnel.reduce(0) {$0 + $1.totalAccount})"
                let totalAmount = "\(self.groupedPersonnel.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
                footerView.configure(totalPerson: totalPerson, totalAccount: totalAccount, totalAmount: totalAmount)
                
                return footerView
            }else { return nil }
        case .odenmezIkram:
            if section == self.groupedUnpaidGratuity.count - 1 {
                guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonReportsFooterView.identifier) as? CommonReportsFooterView else {
                    return nil
                }
                
                let totalAmount = "\(self.groupedUnpaidGratuity.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
                footerView.configure(totalAmount: totalAmount)
                
                return footerView
            }else { return nil }
        case .anaGrupSatis:
            if section == self.groupedMGSReport.count - 1 {
                guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonReportsFooterView.identifier) as? CommonReportsFooterView else {
                    return nil
                }
                
                let totalAmount = "\(self.groupedMGSReport.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
                footerView.configure(totalAmount: totalAmount)
                
                return footerView
            }else { return nil }
        case .acikCekler:
            if section == self.groupedOpenChecks.count - 1 {
                guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonReportsFooterView.identifier) as? CommonReportsFooterView else {
                    return nil
                }
                
                let totalAmount = "\(self.groupedOpenChecks.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
                footerView.configure(totalAmount: totalAmount)
                
                return footerView
            }else { return nil }
        case .indirimDetay:
            if section == self.groupedDiscountDetails.count - 1 {
                guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonReportsFooterView.identifier) as? CommonReportsFooterView else {
                    return nil
                }
                
                let totalAmount = "\(self.groupedDiscountDetails.reduce(0) {$0 + $1.discountAmount}.formatCurrency(currency: self.currency))"
                footerView.configure(totalAmount: totalAmount)
                
                return footerView
            }else { return nil }
        case .odemeDetay:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PaymentDetailFooterView.identifier) as? PaymentDetailFooterView else {
                return nil
            }
            let totalAmount = "\(self.groupedPaymentDetail.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
            let totalAccount = "\(self.groupedPaymentDetail.reduce(0) {$0 + $1.totalAccount})"
            
            footerView.configure(totalAccount: totalAccount, totalAmount: totalAmount)
            
            return footerView
        case .enCokSatanUrunler:
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BestSellingProductFooterView.identifier) as? BestSellingProductFooterView else {
                return nil
            }
            
            let totalAmount = "\(self.groupedEnCokSatan.reduce(0) {$0 + $1.totalAmount}.formatCurrency(currency: self.currency))"
            let totalProduct = "\(Int(self.groupedEnCokSatan.reduce(0) {$0 + $1.totalQuantity}))"
            
            footerView.configure(totalProduct: totalProduct, totalAmount: totalAmount)
            
            return footerView
        default:
            return nil
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.reportType {
        case .anaGrupSatis:
            return self.groupedMGSReport.count
        case .indirimDetay:
            return self.groupedDiscountDetails.count
        case .odemeDetay:
            return self.groupedPaymentDetail.count
        case .odenmezIkram:
            return self.groupedUnpaidGratuity.count
        case .acikCekler:
            return self.groupedOpenChecks.count
        case .personelSatis:
            return self.groupedPersonnel.count
        case .enCokSatanUrunler:
            return self.groupedEnCokSatan.count
        default:
            return 1
        }
    }
}

    //MARK: - BestSellingProductHeaderViewDelegate -
extension ReportDetailsView: BestSellingProductHeaderViewDelegate {
    func didTapHeaderButton(sortByBranch: Bool) {
        self.prepareBSPReport(report: self.enCokSatanUrunler, sortForBranch: sortByBranch)
    }
}

    //MARK: - PaymentDetailHeaderViewDelegate -
extension ReportDetailsView: PaymentDetailHeaderViewDelegate {
    func didTappedPaymentButton(sortByPayment: Bool) {
        self.preparePaymentDetailReport(report: self.paymentDetail, sortForPayment: sortByPayment)
    }
}

    //MARK: - MainGroupSalesHeaderViewDelegate -
extension ReportDetailsView: MainGroupSalesHeaderViewDelegate {
    func didTappedMainButton(sortByBranch: Bool) {
        self.prepareMGSReport(report: self.anaGrupSatis, sortForBranch: sortByBranch)
    }
}

    //MARK: - DiscountDetailHeaderViewDelegate -
extension ReportDetailsView: DiscountDetailHeaderViewDelegate {
    func didTappedDiscountButton(sortByBranch: Bool) {
        self.prepareDiscountReport(report: self.discountDetail, sortForBranch: sortByBranch)
    }
}
