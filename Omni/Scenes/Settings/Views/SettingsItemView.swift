//
//  SettingsItemView.swift
//  Omni
//
//  Created by ahmetAltintop on 1.08.2024.
//

import UIKit

protocol SettingsItemDelegate: AnyObject {
    func didChangeCurrency(currency: HomeModels.Currencies)
    func didChangeLanguage(language: SettingsModel.Languages)
}
    

class SettingsItemView: UIView {
    
    //MARK: - Lifecyle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(item: SettingsModel.SettingsItems){
        self.pickerViewType = item
        self.selectCurrentLanguageInPicker(pickerType: self.pickerViewType)
        
        switch item {
        case .language:
            self.titleLabel.text = "Language".translated()
            
        case .currency:
            self.titleLabel.text = "Currency".translated()
        }
    }
    
    // MARK: - Public -
    weak var delegate: SettingsItemDelegate?
    
    var pickerViewType: SettingsModel.SettingsItems = .language
    
    // MARK: - Private -
    private let languageCodeToLanguageName: [String: String] = [
        "en": "English",
        "tr": "Turkish"
    ]
    
    let currentLanguageCode = Locale.current.languageCode ?? "en"
    
    private var currencyList: [SettingsModel.Currency] = [.def,.tl,.eur,.usd]
    private var languageList: [SettingsModel.Languages] = [.en,.tr]
    
    private var selectedCurrency: String?
    private var selectedLanguage: String?
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel,
                                                       self.pickerView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
        
    
    private func commonInit(){
        self.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        self.pickerView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
    }

    
    private func selectCurrentLanguageInPicker(pickerType: SettingsModel.SettingsItems) {
        switch pickerType {
        case .language:
            let languageCodeToLanguageName: [String: String] = [
                "en": "English",
                "tr": "Turkish"
            ]
            var currentLanguageCode = ""
            let savedLang = UserDefaults.standard.string(forKey: Constants.UserDefaults.SelectedLanguageKey)
            if savedLang == nil {
               currentLanguageCode = Locale.current.languageCode ?? "en"
            }else {
                currentLanguageCode = savedLang ?? "en"
            }
            
            let savedLanguage = UserDefaults.standard.string(forKey: Constants.UserDefaults.SelectedLanguageKey) ?? languageCodeToLanguageName[currentLanguageCode] ?? "English"
            
            if let index = languageList.firstIndex(where: { $0.rawValue == savedLanguage }) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
        case .currency:
            let savedCurrency = UserDefaults.standard.string(forKey: Constants.UserDefaults.savedCurrencyKey) ?? "Default"
            
            if let index = currencyList.firstIndex(where: { $0.rawValue == savedCurrency }) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
}

    //MARK: - UIPickerViewDelegate -

extension SettingsItemView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
           
           if let reusedView = view as? UILabel {
               label = reusedView
           } else {
               label = UILabel()
           }
        
        switch self.pickerViewType {
        case .currency:
            label.text = self.currencyList[row].rawValue.translated()
        case .language:
            label.text = self.languageList[row].rawValue.translated()
        }
           label.textColor = .black
           label.textAlignment = .center
           
           return label
    }
    
}

    //MARK: - UIPickerViewDataSource -

extension SettingsItemView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch self.pickerViewType {
        case .currency:
            return self.currencyList.count
        case .language:
            return self.languageList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch self.pickerViewType {
        case .currency:
            return self.currencyList[row].rawValue
        case .language:
            return self.languageList[row].rawValue.translated()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.pickerViewType {
        case .currency:
            self.selectedCurrency = self.currencyList[row].rawValue
            
            switch self.currencyList[row] {
            case .def:
                self.delegate?.didChangeCurrency(currency: .def)
            case .tl:
                self.delegate?.didChangeCurrency(currency: .tl)
            case .eur:
                self.delegate?.didChangeCurrency(currency: .euro)
            case .usd:
                self.delegate?.didChangeCurrency(currency: .usd)
            }
        case .language:
            self.selectedLanguage = self.languageList[row].rawValue
            self.delegate?.didChangeLanguage(language: self.languageList[row])
        }
    }
    
}

