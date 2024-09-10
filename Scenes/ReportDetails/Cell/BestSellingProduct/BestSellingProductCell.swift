//
//  ReportDetailsCell.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

class BestSellingProductCell: UITableViewCell {
    
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
    
    func setupCell(item: ReportModels.BestSellingProductModel, index: Int, curr: HomeModels.Currencies, isProduct: Bool){
        
        if index % 2 == 0 {
            self.backgroundColor = .clear
        }else {
            self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
        
        self.productLabel.text = isProduct ? item.subeAdi : item.urunAdi
        self.amountLabel.text = "\(Int(item.miktar))"
        priceLabel.text = item.tutar.formatCurrency(currency: curr)
        
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.productLabel,
                                                       self.amountLabel,
                                                       self.priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var productLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
    }()
    
    private func prepareViews() {
        self.contentView.isHidden = true
        self.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
    }
}
