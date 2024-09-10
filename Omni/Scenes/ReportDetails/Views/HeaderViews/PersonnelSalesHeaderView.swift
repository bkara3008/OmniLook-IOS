//
//  PersonnelSalesHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//
import UIKit

class PersonnelSalesHeaderView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cashierName,
                                                       self.personCount,
                                                       self.accountCount,
                                                       self.amount])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var cashierName: UILabel = {
        let label = UILabel()
        label.text = "Cashier_Name".translated()
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
  
    private lazy var personCount: UILabel = {
        let label = UILabel()
        label.text = "Total_Person".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var accountCount: UILabel = {
        let label = UILabel()
        label.text = "Total_Checks".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var amount: UILabel = {
        let label = UILabel()
        label.text = "Amount".translated()
        label.textColor = .white
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private func commonInit() {
        self.addSubview(self.containerStackView)
        self.backgroundColor = .appGreen
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
}
