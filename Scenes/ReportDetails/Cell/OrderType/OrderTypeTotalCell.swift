//
//  OrderTypeTotalCell.swift
//  Omni
//
//  Created by ahmetAltintop on 17.08.2024.
//

import UIKit

class OrderTypeTotalCell: UITableViewCell {
    
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
    
    func setupCell(totalPerson: String, totalAccount: String, totalAmount: String){
        self.totalPerson.text = totalPerson
        self.totalAccount.text = totalAccount
        self.totalAmount.text = totalAmount
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.totalTitle,
                                                       self.totalPerson,
                                                       self.totalAccount,
                                                       self.totalAmount])
        stackView.axis = .horizontal
        stackView.spacing = 4
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
    
    private lazy var totalPerson: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var totalAccount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private lazy var totalAmount: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        return label
    }()
    
    private func prepareViews() {
        self.backgroundColor = .appGreen
        self.contentView.backgroundColor = .appGreen
        
        self.contentView.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.top.bottom.equalToSuperview()
        }
    }
}
