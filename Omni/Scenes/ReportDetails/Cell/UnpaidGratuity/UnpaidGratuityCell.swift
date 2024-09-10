//
//  UnpaidGratuityCell.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit

class UnpaidGratuityCell: UITableViewCell {

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
    
    func setupCell(item: ReportModels.UnpaidGratuityReportModel, index: Int, curr: HomeModels.Currencies){
        
        if index % 2 == 0 {
            self.backgroundColor = .clear
        }else {
            self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        }
        
        self.branchLabel.text = item.subeAdi
        self.personelName.text = item.personelAdi
        self.dateLabel.text = formatDateString(item.tarih)
        self.amount.text = "\(item.tutar.formatCurrency(currency: curr))"
    }
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.branchLabel,
                                                       self.personelName,
                                                       self.dateLabel,
                                                       self.amount])
        stackView.axis = .horizontal
        stackView.spacing = 4
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
    
    private lazy var personelName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 10)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = UIFont(name: "Montserrat-Regular", size: 10)
        return label
    }()
    
    private lazy var amount: UILabel = {
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
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        // Gelen tarihi formatlayacak bir DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // API'den gelen tarih formatı
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // String'i Date nesnesine dönüştür
        if let date = dateFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd.MM.yyyy HH:mm" // İstenen format
            outputFormatter.locale = Locale(identifier: "tr_TR")
            
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }

}
