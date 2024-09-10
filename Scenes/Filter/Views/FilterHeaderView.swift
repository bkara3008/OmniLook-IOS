//
//  FilterHeaderView.swift
//  Omni
//
//  Created by ahmetAltintop on 9.08.2024.
//

import UIKit

class FilterHeaderView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepareViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(title: String) {
        self.headerTitle.text = title
    }
    
    // MARK: - Private -
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Tarih Aralığı"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textColor = .white
        return label
    }()
    
    private func prepareViews() {
        self.backgroundColor = .appBlue
        self.addSubview(self.headerTitle)
        
        self.headerTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerY.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }

}
