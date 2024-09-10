//
//  PaymentDetailHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

protocol PaymentDetailHeaderViewDelegate: AnyObject {
    func didTappedPaymentButton(sortByPayment: Bool)
}

class PaymentDetailHeaderView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    
    weak var delegate: PaymentDetailHeaderViewDelegate?
    
    var isSortedByPayment: Bool = true
    
    func updateLabelsForSorting(isPayment: Bool) {
         if isPayment {
             self.paymentType.font = UIFont(name: "Montserrat-Bold", size: 10)
             self.branch.font = UIFont(name: "Montserrat-Regular", size: 10)
         } else {
             self.paymentType.font = UIFont(name: "Montserrat-Regular", size: 10)
             self.branch.font = UIFont(name: "Montserrat-Bold", size: 10)
         }
     }
    
    //MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.selectionTitleView,
                                                       self.accountCount,
                                                       self.amount])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var selectionTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var branch: UILabel = {
        let label = UILabel()
        label.text = "Branch".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var paymentType: UILabel = {
        let label = UILabel()
        label.text = "Payment_Type".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var seperatorLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
       
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(self.button_Tapped), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var accountCount: UILabel = {
        let label = UILabel()
        label.text = "Number_of_Accounts".translated()
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
        self.backgroundColor = .appGreen
        
        self.addSubview(self.containerStackView)
        self.selectionTitleView.addSubview(self.branch)
        self.selectionTitleView.addSubview(self.seperatorLabel)
        self.selectionTitleView.addSubview(self.paymentType)
        self.selectionTitleView.addSubview(self.button)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
            make.top.bottom.equalToSuperview()
        }
        self.button.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        self.branch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalTo(self.seperatorLabel.snp.leading).offset(-2)
        }
        self.seperatorLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.paymentType.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-2)
            make.leading.equalTo(self.seperatorLabel.snp.trailing).offset(2)
        }
        
    }
    
    // MARK: - Action -
    
    @objc private func button_Tapped() {
        self.isSortedByPayment.toggle()
        self.updateLabelsForSorting(isPayment: self.isSortedByPayment)
        self.delegate?.didTappedPaymentButton(sortByPayment: self.isSortedByPayment)
    }
    
}


