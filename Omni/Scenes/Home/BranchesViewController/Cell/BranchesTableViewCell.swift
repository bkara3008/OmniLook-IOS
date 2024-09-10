//
//  BranchesTableViewCell.swift
//  Omni
//
//  Created by ahmetAltintop on 2.09.2024.
//

import UIKit

class BranchesTableViewCell: UITableViewCell {

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
    
    func setupCell(branchName: String, row: String, isActive: Bool ){
        self.rowLabel.text = row
        
        switch isActive {
        case true:
            self.branchLabel.text = branchName
            self.branchLabel.textColor = .appGreen
            self.branchLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        case false:
            self.branchLabel.text = branchName
            self.branchLabel.textColor = .lightGray.withAlphaComponent(0.65)
            self.branchLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        }
    }
    
    //MARK: - Private -
    
    private lazy var rowLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = .appBlue
        return label
    }()
    
    private lazy var branchLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    private func prepareViews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(self.rowLabel)
        self.contentView.addSubview(self.branchLabel)
        
        self.rowLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.branchLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalTo(self.rowLabel.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
        }
    }
}
