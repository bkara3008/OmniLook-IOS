//
//  MainMenuTotalView.swift
//  Omni
//
//  Created by ahmetAltintop on 11.07.2024.
//

import UIKit

protocol HomeTotalResultViewDelegate: AnyObject {
    func didTappedDiscount()
    func didTappedCiro()
    func didTappedBranches()
}

class HomeTotalResultView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
        self.addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    var targetValue: Double = 0.0
    var currentValue: Double = 0.0
    var animationDuration: TimeInterval = 1.2
    var displayLink: CADisplayLink?
    var startTime: TimeInterval?
    
    var titleType: HomeModels.DashboardTitles?
    
    func configure(titleType: HomeModels.DashboardTitles, text: String){
        self.titleType = titleType
        switch titleType {
        case .totalBranch:
            self.titleLabel.text = titleType.rawValue.translated()
            
            self.AmountLabel.text = text
            self.iconImageView.image = .dashSubeIcon
            
        case .totalPerson:
            self.titleLabel.text = titleType.rawValue.translated()
            self.clickIconImageView.isHidden = true
            let value = Double(text) ?? 0.0
            self.animateLabelToTargetValue(value: value)
            self.iconImageView.image = .dashPersonIcon
            self.bottomSeperator.isHidden = true // en altta olduğu için gizliyoruz
            
        case .totalAcount:
            self.titleLabel.text = titleType.rawValue.translated()
            self.clickIconImageView.isHidden = true
            let value = Double(text) ?? 0.0
            self.animateLabelToTargetValue(value: value)
            self.iconImageView.image = .dashHesapIcon
            
        case .totalDiscount:
            self.titleLabel.text = titleType.rawValue.translated()
            
            let value = Double(text) ?? 0.0
            self.animateLabelToTargetValue(value: value)
            self.iconImageView.image = .dashindirimIcon
            
        case .totalCiro:
            self.titleLabel.text = titleType.rawValue.translated()
            
            let value = Double(text) ?? 0.0
            self.animateLabelToTargetValue(value: value)
            self.iconImageView.image = .dashCiroIcon
        }
    }
    
    weak var delegate: HomeTotalResultViewDelegate?
    
    // MARK: - Private -
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "newspaper.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var clickIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .click
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private lazy var AmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        label.textAlignment = .right
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        return label
    }()
    
    private lazy var bottomSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.clickIconImageView)
        self.addSubview(self.AmountLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.bottomSeperator)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        self.bottomSeperator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        self.clickIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(4)
        }
        self.AmountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func animateLabelToTargetValue(value: Double) {
        targetValue = value
        
        // Animasyonu başlat
        startTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updateLabel))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Action -
    
    @objc private func handleTap() {
        switch self.titleType {
        case .totalCiro:
            self.delegate?.didTappedCiro()
        case .totalDiscount:
            self.delegate?.didTappedDiscount()
        case .totalBranch:
            self.delegate?.didTappedBranches()
        default:
            return
        }
    }
    
    @objc func updateLabel() {
        guard let startTime = startTime else { return }
        let elapsedTime = CACurrentMediaTime() - startTime
        let progress = min(elapsedTime / animationDuration, 1.0)
        currentValue = targetValue * progress
        switch self.titleType {
        case .totalBranch:
            self.AmountLabel.text = "\(currentValue)"
        case .totalCiro:
            self.AmountLabel.text = currentValue.formatCurrency(currency: getAppCurrency())
        case .totalAcount:
            let text = Int(currentValue)
            self.AmountLabel.text = "\(text)"
        case .totalDiscount:
            self.AmountLabel.text = currentValue.formatCurrency(currency: getAppCurrency())
        case .totalPerson:
            let text = Int(currentValue)
            self.AmountLabel.text = "\(text)"
        case .none:
            self.AmountLabel.text = "\(currentValue)"
        }
        if progress == 1.0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
}
