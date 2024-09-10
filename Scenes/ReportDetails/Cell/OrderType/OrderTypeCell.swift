//
//  OrderTypeCell.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit


class OrderTypeCell: UITableViewCell {
    
    // MARK: - Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.prepareViews()
    }
    
    // MARK: - Internal -

    class var identifier: String {
        String(describing: self)
    }
    
    func formatCurrency(value: Double,currency: HomeModels.Currencies) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        switch currency {
        case .def:
            numberFormatter.currencyCode = ""
            numberFormatter.locale = Locale(identifier: "de_DE") // bu formatta para birimi ikonu sonda geliyor. Ve ondalık olarak da düzgün sonuç geliyor.
            numberFormatter.currencySymbol = ""
        case .tl:
            numberFormatter.currencyCode = "TRY"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = "₺ "
        case .euro:
            numberFormatter.currencyCode = "EUR"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = " €"
        case .usd:
            numberFormatter.currencyCode = "USD"
            numberFormatter.locale = Locale(identifier: "de_DE")
            numberFormatter.currencySymbol = "$ "
        }
        
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func setupCell(item: ReportModels.OrderTypeReportModel, index: Int, curr: HomeModels.Currencies){
        
        if index % 2 == 0 {
            self.backgroundColor = .clear
        }else {
            self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
        self.salesType.text = item.satisTuru
        self.personCount.text = "\(item.kisiSayisi)"
        self.accountCount.text = "\(item.hesapSayisi)"
        self.amount.text = "\(item.tutar.formatCurrency(currency: curr))"
        
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.salesType,
                                                       self.personCount,
                                                       self.accountCount,
                                                       self.amount])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var salesType: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var personCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var accountCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var amount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    
    private func prepareViews() {
        self.contentView.isHidden = true
        self.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
    }
}
