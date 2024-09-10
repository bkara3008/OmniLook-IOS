//
//  FinancialReportHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 13.08.2024.
//

import UIKit

class FinancialHeaderView: UIView {
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
        let stackView = UIStackView(arrangedSubviews: [self.branch,
                                                       self.personCount,
                                                       self.amount,
                                                       self.numberOfOpenChecks,
                                                       self.openCheckAmount])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var branch: UILabel = {
        let label = UILabel()
        label.text = "Branch".translated()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var personCount: UILabel = {
        let label = UILabel()
        label.text = "Total_Person".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var amount: UILabel = {
        let label = UILabel()
        label.text = "Amount".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var numberOfOpenChecks: UILabel = {
        let label = UILabel()
        label.text = "Number_of_Open_Checks".translated()
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var openCheckAmount: UILabel = {
        let label = UILabel()
        label.text = "Open_Check_Amount".translated()
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
