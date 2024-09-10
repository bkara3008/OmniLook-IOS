//
//  SettingsViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 1.08.2024.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateSettings(currency: HomeModels.Currencies)
    func backFromLogin(serverUrl: String)
    func didChangeLanguageAndReturn()
}

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
        self.setupPanGesture()
        self.setupDismissKeyboardGesture()
        self.setupLocalizedText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupLocalizedText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
    }
    
    //MARK: - Internal -
    
    //MARK: - Public -
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var fromLogin: Bool = false
    var serverUrl = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedUrlKey) as? String ?? ""
    
    //MARK: - Private -
    
    private let panModalGesture = UIPanGestureRecognizer()
    
    private var selectedCurrency: HomeModels.Currencies = .def
    private var selectedLanguage: SettingsModel.Languages = .tr
    
    private lazy var currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
 
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.languageView,
                                                       self.currencyView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
        
    }()
    
    private lazy var languageView: SettingsItemView = {
        let view = SettingsItemView()
        view.configure(item: .language)
        view.delegate = self
        return view
    }()
    
    private lazy var currencyView: SettingsItemView = {
        let view = SettingsItemView()
        view.configure(item: .currency)
        view.delegate = self
        return view
    }()
    
    private lazy var serverInfoView: SettingsServerInfoView = {
        let view = SettingsServerInfoView()
        view.configure(url: self.serverUrl)
        view.delegate = self
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cancelButton,
                                                       self.saveButton])
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save".translated(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius  = 16
        button.addTarget(self, action: #selector(self.saveButton_Action(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel".translated(), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius  = 16
        button.addTarget(self, action: #selector(self.exitButton_Action(_:)), for: .touchUpInside)
        return button
    }()
    
    private func prepareViews(){
        self.selectedCurrency = getAppCurrency()
        self.selectedLanguage = getAppLanguage()
        
        self.navigationItem.title = "Settings".translated()
        
        self.view.layer.cornerRadius = 16
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.serverInfoView)
        self.view.addSubview(self.selectionStackView)
        self.view.addSubview(self.buttonStackView)
        
        self.serverInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        self.selectionStackView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.serverInfoView.snp.bottom).offset(6)
        }
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.selectionStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
    }
    
    private func setupLocalizedText() {
        self.cancelButton.setTitle("Cancel".translated(), for: .normal)
        self.saveButton.setTitle("Save".translated(), for: .normal)
        self.serverInfoView.setupLocalizedText()
        self.currencyView.configure(item: .currency)
        self.languageView.configure(item: .language)
    }
    
    private func setupPanGesture() {
        self.panModalGesture.addTarget(self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(self.panModalGesture)
    }
    
    private func getCurrencyForString(curr: HomeModels.Currencies) -> String {
        switch curr {
        case .def:
            return SettingsModel.Currency.def.rawValue
        case .tl:
            return SettingsModel.Currency.tl.rawValue
        case .euro:
            return SettingsModel.Currency.eur.rawValue
        case .usd:
            return SettingsModel.Currency.usd.rawValue
        }
    }
    
    private func checkServerURL(url: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(url)/home/FIRMA_GRUBU"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.showAlert(message:"Invalid_URL".translated())
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
                    self.showAlert(message: "Request_Failed".translated())
                    completion(false)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: "No_Data".translated())
                    completion(false)
                }
                return
            }
            
            do {
                let _: [HomeModels.FirmGroupListModel] = try JSONDecoder().decode([HomeModels.FirmGroupListModel].self, from: data)
                DispatchQueue.main.async {
                    completion(true) // Başarılı olduğunda true döndür
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
    
    private func saveSettings() {
        if getAppCurrency() != self.selectedCurrency {
            UserDefaults.standard.set(self.getCurrencyForString(curr: self.selectedCurrency), forKey: Constants.UserDefaults.savedCurrencyKey)
            
            switch self.selectedCurrency {
            case .def:
                self.delegate?.didUpdateSettings(currency: .tl)
            case .tl:
                self.delegate?.didUpdateSettings(currency: .tl)
            case .euro:
                self.delegate?.didUpdateSettings(currency: .euro)
            case .usd:
                self.delegate?.didUpdateSettings(currency: .usd)
            }
        }
        
        UserDefaults.standard.setValue(self.serverUrl, forKey: Constants.UserDefaults.savedUrlKey)

        let currentLanguage = UserDefaults.standard.string(forKey: Constants.UserDefaults.SelectedLanguageKey)
        
        if currentLanguage != selectedLanguage.rawValue {
            UserDefaults.standard.set([selectedLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Constants.UserDefaults.SelectedLanguageKey)
            UserDefaults.standard.synchronize()
            
            self.delegate?.didChangeLanguageAndReturn()
        }
        self.delegate?.backFromLogin(serverUrl: self.serverUrl)
        self.dismiss(animated: true)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Bu, diğer view'ların dokunma olaylarını engellemez.
        self.view.addGestureRecognizer(tapGesture)
    }

    
    //MARK: - Action -
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = .identity
                })
            }
        default:
            break
        }
    }
    
    @objc
    private func saveButton_Action(_ button: UIButton) {
        let serverInfo = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedUrlKey)
     
        if serverInfo == nil || serverInfo as? String != self.serverUrl {
            self.checkServerURL(url: self.serverUrl) { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        self.saveSettings()
                    }else {
                        self.showAlert(message: "Invalid_URL".translated())
                    }
                }
            }
        } else {
            self.saveSettings()
        }
    }
    
    @objc
    private func exitButton_Action(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

    //MARK: - SettingsItemDelegate -

extension SettingsViewController: SettingsItemDelegate {
    func didChangeCurrency(currency: HomeModels.Currencies) {
        self.selectedCurrency = currency
    }
    
    func didChangeLanguage(language: SettingsModel.Languages) {
        self.selectedLanguage = language
    }
}
    //MARK: - SettingsServerInfoViewDelegate -

extension SettingsViewController: SettingsServerInfoViewDelegate {
    func textFieldDidChange(text: String?) {
        self.serverUrl = text ?? ""
    }
    
    func keyboardWillShow(keyboardHeight: CGFloat) {
        // ModalPresentationViewController'da yüksekliği artırın
        let presentedVC = presentationController as? ModalPresentationViewController
        presentedVC?.adjustHeightForKeyboard(keyboardHeight: keyboardHeight / 2)
    }
    
    func keyboardWillHide() {
        let presentedVC = presentationController as? ModalPresentationViewController
        presentedVC?.resetHeight()
    }
}

    //MARK: - ModalContentHeightCalculable -

extension SettingsViewController: ModalContentHeightCalculable {
    func calculateContentHeight() -> CGFloat {
        view.layoutIfNeeded()
        var totalHeight: CGFloat = 0
        
        for subview in view.subviews {
            totalHeight += subview.frame.height
        }
        
        return totalHeight
    }
}
