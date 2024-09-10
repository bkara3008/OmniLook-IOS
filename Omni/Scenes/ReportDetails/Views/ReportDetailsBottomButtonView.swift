//
//  ReportDetailsBottomView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

protocol ReportDetailsBottomButtonViewDelegate: AnyObject {
    func didTappedButton(buttonType: ReportDetails.BottomButtonTypes)
}

class ReportDetailsBottomButtonView: UIView {
    //MARK: - Lifecyle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    var isReport: Bool = false
    
    func configure(buttonType: ReportDetails.BottomButtonTypes){
        self.buttonType = buttonType
        switch buttonType {
        case .home:
            self.titleLabel.text = "Home_Page".translated()
            self.iconImageView.image = UIImage(systemName: "homekit")
        case .report:
            self.titleLabel.text = "Chart".translated()
            self.iconImageView.image = UIImage(systemName: "chart.pie.fill")
        case .filter:
            self.titleLabel.text = "Filter".translated()
            self.iconImageView.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
        }
    }
    
    //MARK: - Public -
    
    weak var delegate: ReportDetailsBottomButtonViewDelegate?
    
    
    //MARK: - Private -
    
    private var buttonType: ReportDetails.BottomButtonTypes = .report
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.button_Tapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private func commonInit(){
        self.addSubview(self.iconImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.button)
        
        self.iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.top.equalToSuperview().offset(6)
            make.centerX.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(2)
            make.centerX.equalTo(self.iconImageView.snp.centerX)
        }
        self.button.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    // MARK: - Action -
    
    @objc
    private func button_Tapped(_ button: UIButton) {
        switch self.buttonType {
        case .home:
            self.delegate?.didTappedButton(buttonType: .home)
        case .report:
            self.isReport.toggle()
            self.titleLabel.text = isReport ?  "List".translated() : "Chart".translated()
            
            self.iconImageView.image = self.isReport ? UIImage(systemName: "list.bullet") : UIImage(systemName: "chart.pie.fill")
            self.delegate?.didTappedButton(buttonType: .report)
        case .filter:
            self.delegate?.didTappedButton(buttonType: .filter)
        }
    }
}
