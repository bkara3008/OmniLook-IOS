//
//  FilterTableViewSectionView.swift
//  Omni
//
//  Created by ahmetAltintop on 11.08.2024.
//

import UIKit

class FilterTableViewSectionView: UITableViewHeaderFooterView {
    // MARK: - Lifecycle -
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.prepareViews()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: - Internal -
    
    var onExpandButtonTapped: (() -> Void)?
    var onSelectionButtonTapped: (() -> Void)?
    
    func configure(title: String, isChecked: Bool, isExpand: Bool){
        self.titleLabel.text = title
        self.iconImageView.image = isChecked ? .checkedBox : .uncheckedBox
        self.expandButton.setImage(UIImage(systemName: isExpand ? "chevron.down" : "chevron.right"), for: .normal)
    }
    
    class var identifier: String {
        String(describing: self)
    }
    
    // MARK: - Private -
    
    private lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.selectionButton_Tapped), for: .touchUpInside)
        return button
      }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkedBox
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
      
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
      
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .white
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.expandButton_Tapped), for: .touchUpInside)
        return button
        }()

    private func prepareViews() {
        self.contentView.backgroundColor = .appBlue.withAlphaComponent(0.4)
        
        self.addSubview(self.iconImageView)
        self.addSubview(self.selectionButton)
        self.addSubview(self.titleLabel)
        self.addSubview(self.expandButton)
        
        self.iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        self.selectionButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(self.expandButton.snp.leading).offset(-6)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(6)
            make.trailing.equalTo(self.expandButton.snp.leading).offset(-6)
        }
        self.expandButton.snp.makeConstraints { make in
            make.height.width.equalTo(26)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    //MARK: - Action -
    
    @objc
    private func expandButton_Tapped() {
        self.onExpandButtonTapped?()
    }
    
    @objc
    private func selectionButton_Tapped() {
        self.onSelectionButtonTapped?()
    }
}
