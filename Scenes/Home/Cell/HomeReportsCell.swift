//
//  HomeReportsCell.swift
//  Omni
//
//  Created by ahmetAltintop on 12.07.2024.
//

import UIKit

protocol HomeReportsCellDelegate: AnyObject {
    func didTappedReportButton(reportType: HomeModels.TempReportTypes)
}

class HomeReportsCell: UICollectionViewCell {
    // MARK: - Lifecycle -

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.commonInit()
    }
    
    // MARK: - Internal -

    class var identifier: String {
        String(describing: self)
    }

    func configureCell(reportType: HomeModels.TempReportTypes, bgColor: UIColor) {
//        self.contentView.backgroundColor = bgColor.withAlphaComponent(0.3)
        self.contentView.backgroundColor = .white.withAlphaComponent(0.82)
        self.reportType = reportType
        
        switch reportType {
        case .gelir:
            self.iconImageView.image = .gelirYeni
            self.reportTitle.text = "Financial_Report".translated()
        case .enCokSatanUrunler:
            self.iconImageView.image = .encoksatan
            self.reportTitle.text = "Best_Selling_Products_report".translated()
        case .siparisTipi:
            self.iconImageView.image = .siparistipi
            self.reportTitle.text = "Order_Type_Report".translated()
        case .personelSatis:
            self.iconImageView.image = .personel
            self.reportTitle.text = "Personnel_Sales_Report".translated()
        case .acikCekler:
            self.iconImageView.image = .acikcek
            self.reportTitle.text = "Open_Checks_Report".translated()
        case .anaGrupSatis:
            self.iconImageView.image = .anagrup
            self.reportTitle.text = "Main_Group_Sales_Report".translated()
        case .indirimDetay:
            self.iconImageView.image = .indirimdetay
            self.reportTitle.text = "Discount_Detail_Report".translated()
        case .odenmezIkram:
            self.iconImageView.image = .odenmezikram
            self.reportTitle.text = "Unpaid_Gratuity_Report".translated()
        case .odemeDetay:
            self.iconImageView.image = .odemedetay
            self.reportTitle.text = "Payment_Detail_Report".translated()
        }
    }
    
    // MARK: - Public -
    
    weak var delegate: HomeReportsCellDelegate?

    // MARK: - Private -
    
    private var reportType: HomeModels.TempReportTypes = .acikCekler
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.button_Action(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .encoksatan
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var reportTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Semibold", size: 12)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
        
    }()

    private func commonInit() {
        self.contentView.layer.cornerRadius = 12
        
        self.contentView.addSubview(self.button)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.reportTitle)
        
        self.button.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.width.height.equalTo(25)
        }
        self.reportTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self.iconImageView.snp.centerY)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-4)
        }
    }
    
    @objc private func button_Action(_ button: UIButton){
        self.delegate?.didTappedReportButton(reportType: self.reportType)
    }
    
}
