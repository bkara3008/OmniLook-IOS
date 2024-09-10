//
//  ReportsDateAndNameView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.08.2024.
//

import UIKit

class ReportsDateView: UIView {
    //MARK: - Lifecyle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    
    func configure(startDate: String, endDate: String){
        let startText = "StartDate_Short".translated()
        let endText = "EndDate_Short".translated()
        
        self.startDateLabel.text = "\(startText):  \(startDate)"
        self.endDateLabel.text = "\(endText):  \(endDate)"
    }
    
    
    //MARK: - Private -
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.startDateLabel,
                                                       self.endDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var startDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var endDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.textAlignment = .left
        label.textColor = .darkGray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private func commonInit(){
        self.addSubview(self.dateStackView)
        
        self.dateStackView.snp.makeConstraints { make in
            make.trailing.bottom.top.equalToSuperview()
            make.leading.equalToSuperview().offset((UIScreen.main.bounds.width) / 2)
        }
    }
    
}
