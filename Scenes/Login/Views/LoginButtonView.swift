//
//  LaunchButtonView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

protocol LoginButtonViewDelegate: AnyObject {
    func didButtonTapped(buttonType: LoginModel.LoginButtonTypes)
}

class LoginButtonView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(buttonType: LoginModel.LoginButtonTypes){
        switch buttonType {
        case .settings:
            self.button.setTitle("Settings".translated(), for: .normal)
            self.button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.backgroundColor = .appBlue
            self.buttonType = .settings
        case .login:
            self.button.setTitle("LOGIN".translated(), for: .normal)
            self.button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 14)
            self.backgroundColor = .appGreen
            self.buttonType = .login
        }
    }
    
    // MARK: - Public -
    
    var buttonType: LoginModel.LoginButtonTypes = .login
    
    // MARK: - Private -
    
    weak var delegate: LoginButtonViewDelegate?
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(self.button_Tapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private func commonInit() {
        self.addSubview(self.button)
        
        self.layer.cornerRadius = 6
        
        self.button.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Action -
    
    @objc
    private func button_Tapped(_ button: UIButton) {
        self.delegate?.didButtonTapped(buttonType: self.buttonType)
    }

}
