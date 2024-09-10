//
//  LaunchLoginView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

protocol LoginComponentViewDelegate: AnyObject {
    func didTappedButtons(buttonType: LoginModel.LoginButtonTypes, username: String?, password: String?)
}

class LoginComponentView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Internal -
    func configureForLocalized() {
        self.usernameTextField.placeholder = "Username".translated()
        self.passwordTextField.placeholder = "Password".translated()
        self.settingsButton.configure(buttonType: .settings)
        self.loginButton.configure(buttonType: .login)
    }
    
    // MARK: - Public -
    
    weak var delegate: LoginComponentViewDelegate?
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textFieldStackView,
                                                       self.buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.usernameTextField,
                                                       self.passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        let username = UserDefaults.standard.string(forKey: Constants.UserDefaults.userName) ?? ""
        textField.text = username
        textField.textColor = .white
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.delegate = self
        
        let placeholderText = "Username".translated()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray.withAlphaComponent(0.4)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underlineView)

        // Autolayout ile underlineView'u ayarla
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        let password = UserDefaults.standard.string(forKey: Constants.UserDefaults.password) ?? ""
        textField.text = password
        textField.textColor = .white
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.isSecureTextEntry = true
        
        let placeholderText = "Password".translated()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray.withAlphaComponent(0.4)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underlineView)

        // Autolayout ile underlineView'u ayarla
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return textField
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.loginButton,
                                                       self.settingsButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var settingsButton: LoginButtonView = {
        let view = LoginButtonView()
        view.delegate = self
        view.configure(buttonType: .settings)
        return view
    }()
    
    private lazy var loginButton: LoginButtonView = {
        let view = LoginButtonView()
        view.delegate = self
        view.configure(buttonType: .login)
        return view
    }()
    
    private func commonInit() {
        self.addSubview(self.containerStackView)
        
        self.passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
}

    //MARK: - LoginButtonViewDelegate -

extension LoginComponentView: LoginButtonViewDelegate {
    func didButtonTapped(buttonType: LoginModel.LoginButtonTypes) {
        
        let username = self.usernameTextField.text ?? ""
        let password = self.passwordTextField.text?.isEmpty == false ? self.passwordTextField.text : ""
        
        self.delegate?.didTappedButtons(buttonType: buttonType, username: username, password: password)
    }
}

    //MARK: - UITextFieldDelegate -

extension LoginComponentView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Klavyeyi kapatır
        return true
    }
}
