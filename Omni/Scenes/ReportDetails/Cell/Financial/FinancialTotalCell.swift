//
//  FinancialTotalCell.swift
//  Omni
//
//  Created by ahmetAltintop on 16.08.2024.
//

import UIKit

class FinancialTotalCell: UITableViewCell {

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
    
    func configure(personTitle: String, totalAmount: String, openCheckNumber: String, openCheckAmount: String){
        self.personCount.text = personTitle
        self.totalAmount.text = totalAmount
        self.openCheckNumber.text = openCheckNumber
        self.openCheckAmount.text = openCheckAmount
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.totalTitle,
                                                       self.personCount,
                                                       self.totalAmount,
                                                       self.openCheckNumber,
                                                       self.openCheckAmount])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var totalTitle: UILabel = {
        let label = UILabel()
        label.text = "TOTAL".translated()
        label.textColor = .white
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var personCount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var openCheckNumber: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var openCheckAmount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var totalAmount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private func prepareViews() {
        self.contentView.backgroundColor = .appGreen
        self.contentView.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.bottom.equalToSuperview()
        }
    }
}
