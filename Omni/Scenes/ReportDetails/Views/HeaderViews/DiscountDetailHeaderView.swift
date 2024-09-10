//
//  DiscountDetailHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

protocol DiscountDetailHeaderViewDelegate: AnyObject {
    func didTappedDiscountButton(sortByBranch: Bool)
}

class DiscountDetailHeaderView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    
    weak var delegate: DiscountDetailHeaderViewDelegate?
    
    var isSortedByBranch: Bool = true
    
    func updateLabelsForSorting(isBranch: Bool) {
         if isBranch {
             self.branch.font = UIFont(name: "Montserrat-Bold", size: 8)
             self.discount.font = UIFont(name: "Montserrat-Regular", size: 8)
         } else {
             self.branch.font = UIFont(name: "Montserrat-Regular", size: 8)
             self.discount.font = UIFont(name: "Montserrat-Bold", size: 8)
         }
     }
    
    //MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.selectionTitleView,
                                                       self.cashierName,
                                                       self.tableNo,
                                                       self.discountAmount])
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
    
    private lazy var discount: UILabel = {
        let label = UILabel()
        label.text = "Discount".translated()
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
    
    private lazy var cashierName: UILabel = {
        let label = UILabel()
        label.text = "Personnel".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var tableNo: UILabel = {
        let label = UILabel()
        label.text = "Table_Number".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var discountAmount: UILabel = {
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
        self.selectionTitleView.addSubview(self.discount)
        self.selectionTitleView.addSubview(self.button)
        
        self.containerStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(6)
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
        self.discount.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-2)
            make.leading.equalTo(self.seperatorLabel.snp.trailing).offset(2)
        }
        
    }
    
    // MARK: - Action -
    
    @objc private func button_Tapped() {
        self.isSortedByBranch.toggle()
        self.updateLabelsForSorting(isBranch: self.isSortedByBranch)
        self.delegate?.didTappedDiscountButton(sortByBranch: self.isSortedByBranch)
    }
}

