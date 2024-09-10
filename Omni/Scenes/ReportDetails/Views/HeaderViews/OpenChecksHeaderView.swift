//
//  OpenChecksHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//
import UIKit

class OpenChecksHeaderView: UIView {
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
                                                       self.tableNo,
                                                       self.totalAmount])
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
    
    private lazy var tableNo: UILabel = {
        let label = UILabel()
        label.text = "Table_Number".translated()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    
    private lazy var totalAmount: UILabel = {
        let label = UILabel()
        label.text = "Total_Amount".translated()
        label.textColor = .white
        label.textAlignment = .right
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


