//
//  SettingsServerInfoView.swift
//  Omni
//
//  Created by ahmetAltintop on 1.08.2024.
//

import UIKit

protocol SettingsServerInfoViewDelegate: AnyObject {
    func keyboardWillShow(keyboardHeight: CGFloat)
    func keyboardWillHide()
    func textFieldDidChange(text: String?)
}

class SettingsServerInfoView: UIView {
    
    //MARK: - Lifecyle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
        self.setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Internal -
    
    func configure(url: String){
        self.urlTextField.text = url
        self.urlTextField.placeholder = "Server_Info".translated()
        self.titleLabel.text = "Server_Info".translated()
    }
    
    func setupLocalizedText(){
        self.urlTextField.placeholder = "Server_Info".translated()
        self.titleLabel.text = "Server_Info".translated()
    }
    // MARK: - Public -
    
    weak var delegate: SettingsServerInfoViewDelegate?
    
    // MARK: - Private -
    
    private var urlTextFieldBottomConstraint: NSLayoutConstraint!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Server_Info".translated()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Monserrat-SemiBold", size: 16)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Server_Info".translated()
        textField.textColor = .black
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.delegate = self
        
        // Bu kısım placeholder en solda gelmesin diye var . .
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()

    
    private func commonInit() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.urlTextField)
        self.addSubview(self.separatorView)
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(2)
            make.centerX.equalToSuperview()
        }
        
        self.urlTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
        }
        self.urlTextFieldBottomConstraint = self.urlTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        self.urlTextFieldBottomConstraint.isActive = true
        
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.urlTextField.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Keyboard Handling -
     
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Action -
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height

            self.separatorView.isHidden = true
            self.titleLabel.isHidden = true
            self.urlTextFieldBottomConstraint.constant = -30

            // Delegate aracılığıyla SettingsViewController'a bildirim gönder
            self.delegate?.keyboardWillShow(keyboardHeight: keyboardHeight)

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        self.urlTextFieldBottomConstraint.constant = -8
        self.separatorView.isHidden = false
        self.titleLabel.isHidden = false
        
        delegate?.keyboardWillHide()

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}

    //MARK: - UITextFieldDelegate -

extension SettingsServerInfoView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.urlTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        self.delegate?.textFieldDidChange(text: updatedText)
        return true
    }
}
