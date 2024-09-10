//
//  PersonnelCell.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

class PersonnelCell: UITableViewCell {

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
    
    func setupCell(item: ReportModels.PersonnelSalesReportModel, index: Int, curr: HomeModels.Currencies){
        
        if index % 2 == 0 {
            self.backgroundColor = .clear
        }else {
            self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
        
        self.cashierName.text = item.kasiyerAdi
        self.personCount.text = "\(item.kisiSayisi)"
        self.accountCount.text = "\(item.hesapSayisi)"
        self.amount.text = "\(item.toplamTutar.formatCurrency(currency: curr))"
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cashierName,
                                                       self.personCount,
                                                       self.accountCount,
                                                       self.amount])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var cashierName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var personCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var accountCount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var amount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private func prepareViews() {
        self.contentView.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.bottom.equalToSuperview()
        }
    }
}
