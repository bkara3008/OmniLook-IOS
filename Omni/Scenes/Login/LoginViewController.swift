//
//  LaunchViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
        self.setupLocalizedText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocalizedText()
    }
    
    //MARK: - Public -
    var username: String = ""
    var password: String = ""
    var userID: String = ""
    
    //MARK: - Private -
    
    private var urlString = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedUrlKey) as? String ?? ""
    
    private var dashboardData: [ReportModels.DashboardDataModel] = []
    
    private var firmGroupList: [HomeModels.FirmGroupListModel] = []
    private var allFirmList: [HomeModels.FirmListModel] = []
    private var userModel: [ReportModels.LoginModel] = []
    
    private var financialData: [ReportModels.FinancialReportModel] = []
    private var discountData: [ReportModels.DiscountDetailReportModel] = []
    private var orderTypeData: [ReportModels.OrderTypeReportModel] = []
    
    private var currency: HomeModels.Currencies = .def
    
    private var activeBranches: [String] = []
    private var totalPerson = ""
    private var grandTotal = ""
    private var totalBranch = ""
    private var totalDiscount = ""
    private var totalChecks = ""
    
    private let modalPresentDelegate = ModalPresentationViewDelegate()
    
    private lazy var appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logoBeyazz
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var poweredBy: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .poweredBy
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .loginBG
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var novaLookLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .novaLogo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var loginView: LoginComponentView = {
        let view = LoginComponentView()
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var customerSupportLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        return label
    }()
    
    private lazy var customerSupportButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.customerButton_Tapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var phoneIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .iconPhone
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func prepareViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.bgImageView)
        self.view.addSubview(self.novaLookLogo)
        self.view.addSubview(self.loginView)
        self.view.addSubview(self.poweredBy)
        self.view.addSubview(self.customerSupportLabel)
        self.view.addSubview(self.phoneIcon)
        self.view.addSubview(self.customerSupportButton)
        
        self.customerSupportButton.snp.makeConstraints { make in
            make.leading.equalTo(self.phoneIcon.snp.leading)
            make.trailing.equalTo(self.customerSupportLabel.snp.trailing)
            make.centerY.equalTo(self.customerSupportLabel)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        self.phoneIcon.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.centerY.equalTo(self.customerSupportLabel.snp.centerY)
            make.trailing.equalTo(self.customerSupportLabel.snp.leading).offset(-2)
        }
        
        self.customerSupportLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.poweredBy.snp.top).offset(-64)
        }
        
        self.poweredBy.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(80)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        self.novaLookLogo.snp.makeConstraints { make in
            make.height.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.loginView.snp.top).offset(-36)
        }
        
        self.bgImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.loginView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(280)
        }
    }
    
    private func setupLocalizedText() {
        self.customerSupportLabel.text = "Customer_Support_Line".translated()
        self.loginView.configureForLocalized()
    }
    
    private func saveDefaultsValuesIfNeeded() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Constants.UserDefaults.savedFirmIDsKey)
        
        
        // Tüm firma ID'lerini kaydet
        let firmIDs = self.allFirmList.map { $0.firmaID }
        if defaults.array(forKey: Constants.UserDefaults.savedFirmIDsKey) == nil {
            defaults.set(firmIDs, forKey: Constants.UserDefaults.savedFirmIDsKey)
        }
        
        // Login işlemi gerçekleşirse kaydediyor
        defaults.removeObject(forKey: Constants.UserDefaults.userName)
        defaults.removeObject(forKey: Constants.UserDefaults.password)
        defaults.set(self.username, forKey: Constants.UserDefaults.userName)
        defaults.set(self.password, forKey: Constants.UserDefaults.password)
        
        // Kullanıcı login olurken bir günlük data çekecek.
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.savedStartDateKey)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.savedEndDateKey)
        let today = Date()
        if defaults.object(forKey: Constants.UserDefaults.savedStartDateKey) == nil {
            defaults.set(today, forKey: Constants.UserDefaults.savedStartDateKey)
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
    
    private func getCommonParameters() -> (currCode: String, startDate: String, endDate: String, firmIDs: String) {
        
        let savedCurr = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedCurrencyKey) ?? "USD"
        let currCode = getCurrencyCode(savedCurrency: savedCurr as! String)
        
        let currentDate = Date()
        
        let startDate = DateFormatter.string(from: currentDate)
        let endDate = DateFormatter.string(from: currentDate)
        
        var IDs: [Int] = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedFirmIDsKey) as? [Int] ?? [-1]
        if IDs.isEmpty {
            IDs = [-1]
        }
        let firmIDs = IDs.map { String($0) }.joined(separator: ",")
        
        return ("\(currCode)", startDate, endDate, firmIDs)
    }
    
    private func loadFirmList() {
        let dispatchGroup = DispatchGroup()
        
        // Firma Listesini Yükle
        dispatchGroup.enter()
        self.getAllFirmList { success in
            if success {
                dispatchGroup.leave()
            } else {
                // Başarısız olursa, DispatchGroup'u bitir ve hata göster
                dispatchGroup.leave()
                DispatchQueue.main.async {
                    self.showAlert(message: NSLocalizedString("Failed_To_Load_Firm_List", comment: "Firma Listesi Yüklenemedi"))
                }
            }
        }
        
        // Firma Listesi yüklendikten sonra Dashboard verilerini yükle
        dispatchGroup.notify(queue: .main) {
            self.saveDefaultsValuesIfNeeded()
            self.toHomeViewController()
        }
    }

    private func getAllFirmList(completion: @escaping (Bool) -> Void) {
        var allFirmDataLoaded = true
        let dispatchGroup = DispatchGroup()
        
        for groupID in self.firmGroupList.map({ $0.firmaGrupID }) {
            dispatchGroup.enter()
            
            let idString = groupID
            let urlString = AppConfig.shared.getUrl(for: "FIRMA_LISTESI?kullaniciid=\(self.userID)&firmagrubuid=\(idString)")
            
            guard let url = URL(string: urlString) else {
                allFirmDataLoaded = false
                dispatchGroup.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("İstek başarısız: \(error.localizedDescription)")
                    allFirmDataLoaded = false
                    dispatchGroup.leave()
                    return
                }
                
                guard let data = data else {
                    allFirmDataLoaded = false
                    dispatchGroup.leave()
                    return
                }
                
                do {
                    var firmList = try JSONDecoder().decode([HomeModels.FirmListModel].self, from: data)
                    firmList = firmList.map { firm in
                        var firm = firm
                        firm.firmaGrupID = groupID
                        return firm
                    }
                    DispatchQueue.main.async {
                        self.allFirmList.append(contentsOf: firmList)
                        self.saveDefaultsValuesIfNeeded()
                    }
                } catch {
                    print("JSON decode işlemi başarısız: \(error.localizedDescription)")
                    allFirmDataLoaded = false
                }
                dispatchGroup.leave()
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(allFirmDataLoaded)
        }
    }
    
    private func checkServerURL(url: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(url)/home/FIRMA_GRUBU"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.showAlert(message: NSLocalizedString("Invalid_URL", comment: "Geçersiz URL"))
                completion(false)
            }
            return
        }
        
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(message: NSLocalizedString("Request_Failed", comment: "İstek başarısız oldu. Lütfen tekrar deneyin."))
                    completion(false)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: NSLocalizedString("No_Data", comment: "Sunucudan veri alınamadı."))
                    completion(false)
                }
                return
            }
            
            do {
                self.firmGroupList = try JSONDecoder().decode([HomeModels.FirmGroupListModel].self, from: data)
                if !self.firmGroupList.isEmpty {
                    completion(true)
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: NSLocalizedString("No_Firm_Group_Data", comment: "Firma Grup Verisi Alınamadı."))
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
    
    private func getUserID(userName: String, password: String){
        let pass = password.hashMD5()
        let urlString = "\(AppConfig.shared.serverUrl)/home/KULLANICI_KONTROL?kullaniciAdi=\(userName)&sifre=\(pass)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.showAlert(message: NSLocalizedString("Invalid_URL", comment: "Geçersiz URL"))
            }
            return
        }
        
        self.showLoader()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(message: NSLocalizedString("Request_Failed", comment: "İstek başarısız oldu. Lütfen tekrar deneyin."))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: NSLocalizedString("No_Data", comment: "Sunucudan veri alınamadı."))
                }
                return
            }
            
            do {
                self.userModel = try JSONDecoder().decode([ReportModels.LoginModel].self, from: data)
                DispatchQueue.main.async {
                    if self.userModel.count != 0 {
                        self.userID = "\(Int(self.userModel[0].kullaniciID))"
                        UserDefaults.standard.setValue(self.userID, forKey: Constants.UserDefaults.userID)
                        self.loadFirmList()
                    }else {
                        self.showAlert(message: "Geçersiz kullanıcı adı veya şifre".translated())
                        return
                    }
                }
            } catch {
                DispatchQueue.main.async {
                }
            }
        }.resume()
    }
    
    private func loginCheck() {
        self.firmGroupList.removeAll()
        self.allFirmList.removeAll()
        
        if self.urlString != ""  {
            self.checkServerURL(url: self.urlString) { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        self.getUserID(userName: self.username, password: self.password)
                    } else {
                        self.showAlert(message: NSLocalizedString("Invalid_URL", comment: "Geçersiz URL"))
                    }
                }
            }
        }else{
            self.showAlert(message: NSLocalizedString("Enter_Url", comment: "Url Gir."))
        }
        
    }
    
    // to HomeViewController
    private func toHomeViewController(){
        let HomeVC = HomeViewController()
        HomeVC.modalPresentationStyle = .fullScreen
        
        HomeVC.allFirmList = self.allFirmList
        HomeVC.firmGroupList = self.firmGroupList
        
        self.navigationController?.pushViewController(HomeVC, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Action -
    
    @objc
    private func customerButton_Tapped() {
        if let url = URL(string: "tel://4446664"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

    //MARK: - LoginComponentViewDelegate -

extension LoginViewController: LoginComponentViewDelegate {
    func didTappedButtons(buttonType: LoginModel.LoginButtonTypes, username: String?, password: String?) {
        switch buttonType {
        case .settings:
            self.view.endEditing(true)
            
            let settingsVC = SettingsViewController()
            settingsVC.delegate = self
            settingsVC.fromLogin = true
            settingsVC.transitioningDelegate = self.modalPresentDelegate
            settingsVC.modalPresentationStyle = .custom
            present(settingsVC,animated: true,completion: nil)
            
        case .login:
            self.view.endEditing(true)
            
            if username == "" || username == nil || password == "" || password == nil {
                showAlert(message: "Lütfen geçerli Kullanıcı Adı ve Şifre giriniz".translated())
            }else {
                self.username = username!
                self.password = password!
                self.loginCheck()
            }
        }
    }
}

    //MARK: - SettingsViewControllerDelegate -
extension LoginViewController: SettingsViewControllerDelegate {
    func didChangeLanguageAndReturn() {
        self.setupLocalizedText()
    }
    
    func didUpdateSettings(currency: HomeModels.Currencies) {
        self.currency = currency
    }
    
    func backFromLogin(serverUrl: String) {
        self.urlString = serverUrl
    }
}

