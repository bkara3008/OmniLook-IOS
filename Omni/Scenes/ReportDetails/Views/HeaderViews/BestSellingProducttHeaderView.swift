//
//  BSPReportHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 13.08.2024.
//

import UIKit

protocol BestSellingProductHeaderViewDelegate: AnyObject {
    func didTapHeaderButton(sortByBranch: Bool)
}

class BestSellingProducttHeaderView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    weak var delegate: BestSellingProductHeaderViewDelegate?
    
    var isSortedByBranch: Bool = true
    
    func updateLabelsForSorting(isBranch: Bool) {
         if isBranch {
             self.product.font = UIFont(name: "Montserrat-Regular", size: 12)
             self.branch.font = UIFont(name: "Montserrat-Bold", size: 12)
         } else {
             self.product.font = UIFont(name: "Montserrat-Bold", size: 12)
             self.branch.font = UIFont(name: "Montserrat-Regular", size: 12)
         }
     }
    
    //MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.containerView,
                                                       self.amountLabel,
                                                       self.priceTitle])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var branch: UILabel = {
        let label = UILabel()
        label.text = "Branch".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var product: UILabel = {
        let label = UILabel()
        label.text = "Product".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
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
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount_".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var priceTitle: UILabel = {
        let label = UILabel()
        label.text = "Amount".translated()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private func commonInit() {
        self.backgroundColor = .appGreen
        
        self.addSubview(self.containerStackView)
        
        self.containerView.addSubview(self.branch)
        self.containerView.addSubview(self.product)
        self.containerView.addSubview(self.seperatorLabel)
        self.containerView.addSubview(self.button)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
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
        self.product.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-2)
            make.leading.equalTo(self.seperatorLabel.snp.trailing).offset(2)
        }
    }
    
    // MARK: - Action -
    
    @objc private func button_Tapped() {
        self.isSortedByBranch.toggle()
        self.updateLabelsForSorting(isBranch: self.isSortedByBranch)
        self.delegate?.didTapHeaderButton(sortByBranch: self.isSortedByBranch) //
    }
    
}
