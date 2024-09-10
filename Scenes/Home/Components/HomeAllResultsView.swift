//
//  HomeAllResultsView.swift
//  Omni
//
//  Created by ahmetAltintop on 12.07.2024.
//

import UIKit


protocol HomeAllResultsViewDelegate: AnyObject {
    func didTappedCiroView()
    func didTappedDiscountView()
    func didTappedBranchesView()
}

class HomeAllResultsView: UIView {
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: HomeAllResultsViewDelegate?
    
    func configure(data: ReportModels.DashboardDataModel, currency: HomeModels.Currencies) {
        let totalBranch = data.totalBranch
        let totalAccount = data.totalAccount
        let grandTotal = data.grandTotal
        let totalDiscount = data.totalDiscount
        let totalPerson = data.totalPerson
        
        self.totalPersonView.configure(titleType: .totalPerson, text: totalPerson)
        self.totalAccountView.configure(titleType: .totalAcount, text: totalAccount)
        self.totalDiscountView.configure(titleType: .totalDiscount, text: totalDiscount)
        self.totalCiroView.configure(titleType: .totalCiro, text: grandTotal)
        self.totalBranchView.configure(titleType: .totalBranch, text: totalBranch)
    }
    
    // MARK: - Private Properties -
    
    private static let viewHeight = ((UIScreen.main.bounds.width - 48) / 2 ) / 2 - 20
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.totalCiroView,
                                                       self.totalDiscountView,
                                                       self.totalBranchView,
                                                       self.totalAccountView,
                                                       self.totalPersonView])
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var totalBranchView: HomeTotalResultView = {
        let view = HomeTotalResultView()
        view.delegate = self
        return view
    }()
    
    private lazy var totalAccountView: HomeTotalResultView = {
        let view = HomeTotalResultView()
        return view
    }()
    
    private lazy var totalPersonView: HomeTotalResultView = {
        let view = HomeTotalResultView()
        return view
    }()
    
    private lazy var totalDiscountView: HomeTotalResultView = {
        let view = HomeTotalResultView()
        view.delegate = self
        return view
    }()
    
    private lazy var totalCiroView: HomeTotalResultView = {
        let view = HomeTotalResultView()
        view.delegate = self
        return view
    }()
    
    private func commonInit(){
        self.backgroundColor = .clear
        
        self.addSubview(self.containerStackView)
        
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview().inset(2)
        }
    }
}

extension HomeAllResultsView: HomeTotalResultViewDelegate {
    func didTappedBranches() {
        self.delegate?.didTappedBranchesView()
    }
    
    func didTappedDiscount() {
        self.delegate?.didTappedDiscountView()
    }
    
    func didTappedCiro() {
        self.delegate?.didTappedCiroView()
    }
}
