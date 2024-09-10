//
//  HomeReportsView.swift
//  Omni
//
//  Created by ahmetAltintop on 12.07.2024.
//

import UIKit

protocol HomeReportsViewDelegate: AnyObject {
    func didTappedReports(reportType: HomeModels.TempReportTypes)
}

class HomeReportsView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: HomeReportsViewDelegate?
    
    // MARK: - Private Properties-
    
    private let colors: [UIColor] = HomeModels.ColorTypes.allCases.map {$0.colors}
    private let reportTypes = HomeModels.TempReportTypes.allCases
    
    private static let cellWitdh = ((UIScreen.main.bounds.width - 48) - 12 ) / 3
    private static let cellHeight = HomeReportsView.cellWitdh - 40
    private static let collectionViewHeight = (HomeReportsView.cellHeight * 3 ) + 12
    
    // MARK: - Private -
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        layout.itemSize = CGSize(width: HomeReportsView.cellWitdh,
                                 height: HomeReportsView.cellHeight)

        let collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: layout)
        collectionView.register(HomeReportsCell.self, forCellWithReuseIdentifier: HomeReportsCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
        
    }()
    
    private func commonInit() {
        self.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(HomeReportsView.collectionViewHeight)
        }
        
    }
}

// MARK: - UICollectionViewDelegate -

extension HomeReportsView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource -

extension HomeReportsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeReportsCell.identifier, for: indexPath) as? HomeReportsCell
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configureCell(reportType: self.reportTypes[indexPath.row], bgColor: self.colors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reportTypes.count
    }
}

// MARK: - HomeReportsCellDelegate -

extension HomeReportsView: HomeReportsCellDelegate {
    func didTappedReportButton(reportType: HomeModels.TempReportTypes) {
        self.delegate?.didTappedReports(reportType: reportType)
    }
}
