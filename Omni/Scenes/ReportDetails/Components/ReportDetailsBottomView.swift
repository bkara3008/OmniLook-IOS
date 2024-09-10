//
//  ReportDetailsBottomView.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import UIKit

protocol ReportDetailsBottomViewDelegate: AnyObject {
    func didTappedButton(buttonType: ReportDetails.BottomButtonTypes)
}

class ReportDetailsBottomView: UIView {
    //MARK: - Lifecyle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public -
    weak var delegate: ReportDetailsBottomViewDelegate?
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.homeButtonView,
                                                       self.reportButtonView,
                                                       self.filterButtonView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var homeButtonView: ReportDetailsBottomButtonView = {
        let view = ReportDetailsBottomButtonView()
        view.configure(buttonType: .home)
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var reportButtonView: ReportDetailsBottomButtonView = {
        let view = ReportDetailsBottomButtonView()
        view.configure(buttonType: .report)
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var filterButtonView: ReportDetailsBottomButtonView = {
        let view = ReportDetailsBottomButtonView()
        view.configure(buttonType: .filter)
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    
    private func commonInit(){
        self.backgroundColor = .clear
        
        self.addSubview(self.containerStackView)
        
        self.homeButtonView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        self.reportButtonView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        self.filterButtonView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
}
extension ReportDetailsBottomView: ReportDetailsBottomButtonViewDelegate {
    func didTappedButton(buttonType: ReportDetails.BottomButtonTypes) {
        self.delegate?.didTappedButton(buttonType: buttonType)
    }
}
