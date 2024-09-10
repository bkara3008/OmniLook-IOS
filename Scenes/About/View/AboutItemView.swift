//
//  AboutItemView.swift
//  Omni
//
//  Created by ahmetAltintop on 14.08.2024.
//

import UIKit


class AboutItemView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(title: String, description: String) {
        self.headerTitle.text = title
        self.desriptionTitle.text = description
    }
    
    // MARK: - Public -
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.headerTitle,
                                                       self.desriptionTitle])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var desriptionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Regular", size: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()

    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.addSubview(self.containerStackView)
        self.addSubview(self.bottomSeperatorView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(12)
            make.bottom.equalTo(self.bottomSeperatorView.snp.top).offset(-2)
        }
        self.bottomSeperatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }

}
