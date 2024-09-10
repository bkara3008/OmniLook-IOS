//
//  FilterTableViewSection.swift
//  Omni
//
//  Created by ahmetAltintop on 10.08.2024.
//

import UIKit

protocol FilterTableViewCellDelegate: AnyObject {
    func didToggleCheckbox(at indexPath: IndexPath)
}

class FilterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.prepareViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.prepareViews()
    }
    
    // MARK: - Internal -

    class var identifier: String {
        String(describing: self)
    }
    
    func setupCell(branchName: String, isChecked: Bool, indexPath: IndexPath) {
        self.titleLabel.text = branchName
        self.checkboxIcon.image = isChecked ? .checkedBox : .uncheckedBox
        self.indexPath = indexPath
        self.checked = isChecked
    }
    
    // MARK: - Public -
    
    var checked: Bool = true
    weak var delegate: FilterTableViewCellDelegate?
    
    // MARK: - Private -
    private var indexPath: IndexPath?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        return label
    }()
    
    private lazy var containerButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.containerButton_Tapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkboxIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .checkedBox
        return imageView
    }()
    
    private func prepareViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.checkboxIcon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.containerButton)
        
        self.containerButton.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        self.checkboxIcon.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.checkboxIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(4)
        }
    }
    
    // MARK: - Action -
    
    @objc func containerButton_Tapped() {
        self.checked.toggle()
        self.checkboxIcon.image = checked ? .checkedBox : .uncheckedBox
        if let indexPath = indexPath {
            delegate?.didToggleCheckbox(at: indexPath)
        }
        
    }
}
