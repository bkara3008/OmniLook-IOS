//
//  FinancialCell.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

class FinancialCell: UITableViewCell {

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
    
    func setupCell(item: ReportModels.FinancialReportModel, index: Int, curr: HomeModels.Currencies){
        
        if index % 2 == 0 {
            self.backgroundColor = .clear
        }else {
            self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
        
        let doubleAmount = Double(round(100 * item.acikCekTutari) / 100)
        
        self.branchLabel.text = item.subeAdi
        self.personCount.text = "\(item.kisiSayisi)"
        self.amount.text = "\(item.toplamTutar.formatCurrency(currency: curr))"
        self.openCheckNumber.text = "\(item.acikCekAdedi)"
        self.openCheckAmount.text = "\(doubleAmount.formatCurrency(currency: curr))"
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.branchLabel,
                                                       self.personCount,
                                                       self.amount,
                                                       self.openCheckNumber,
                                                       self.openCheckAmount])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var branchLabel: UILabel = {
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
    
    private lazy var amount: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var openCheckNumber: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var openCheckAmount: UILabel = {
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
