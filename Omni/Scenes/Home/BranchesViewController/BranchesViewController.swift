//
//  BranchesViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 2.09.2024.
//

import UIKit

class BranchesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViews()
        self.setupPanGesture()
    }
    
    //MARK: - Internal -
    
    func prepareBranchesData(allBranches: [HomeModels.FirmListModel], activeBranches: [String]) {
        self.branches = allBranches.map { firmListModel in
            let branchName = firmListModel.firmaAdi
            let isActive = activeBranches.contains(branchName)
            return BranchesModel(branch: branchName, isActive: isActive)
        }
        self.branches.sort {!$0.isActive && $1.isActive }
        self.tableView.reloadData()
    }
    
    //MARK: - Public -
    
    //MARK: - Private -
    private var branches: [BranchesModel] = []
    
    private var isSorting = false
    
    private let panModalGesture = UIPanGestureRecognizer()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.imageView?.tintColor = .appBlue
        button.setTitle("", for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.2)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.filterButton_Tapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Branches".translated()
        label.textColor = .appBlue
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BranchesTableViewCell.self,
                           forCellReuseIdentifier: BranchesTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    private func prepareViews() {
        self.view.layer.cornerRadius = 16
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.filterButton)
        self.view.addSubview(self.topLineView)
        self.view.addSubview(self.headerTitle)
        self.view.addSubview(self.tableView)
        
        self.filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.headerTitle.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.height.width.equalTo(36)
        }
        self.topLineView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(32)
        }
        
        self.headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topLineView.snp.bottom).offset(12)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.headerTitle.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalToSuperview()
        }

    }
    
    private func setupPanGesture() {
        self.panModalGesture.addTarget(self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(self.panModalGesture)
    }
    
    //MARK: - Action -
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.transform = .identity
                })
            }
        default:
            break
        }
    }
    
    @objc private func filterButton_Tapped() {
        self.isSorting.toggle()
        
        self.branches.sort { isSorting ? $0.isActive && !$1.isActive : !$0.isActive && $1.isActive }
        
        self.tableView.reloadData()
    }

}

    //MARK: - UItableViewDelegate & DataSource -

extension BranchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BranchesTableViewCell.identifier, for: indexPath) as? BranchesTableViewCell
        else {
            return UITableViewCell()
        }
        let item = self.branches[indexPath.row]
        let row = "\(indexPath.row + 1) -"
        cell.setupCell(branchName: item.branch, row: row,  isActive: item.isActive)
        return cell
    }
}

extension BranchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension BranchesViewController: ModalContentHeightCalculable {
    func calculateContentHeight() -> CGFloat {
        self.view.layoutIfNeeded()
        
        
        var totalHeight: CGFloat = 0
        
        
        let numberOfSections = tableView.numberOfSections
        for section in 0..<numberOfSections {
            
            totalHeight += tableView.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0
            
            let numberOfRows = tableView.numberOfRows(inSection: section)
            for row in 0..<numberOfRows {
                totalHeight += tableView.delegate?.tableView?(tableView, heightForRowAt: IndexPath(row: row, section: section)) ?? 0
            }
        }
        totalHeight += self.topLineView.frame.height
        totalHeight += self.headerTitle.frame.height
        
        self.view.layoutIfNeeded()
        
        let maxHeight = UIScreen.main.bounds.height * 0.85
        return min(totalHeight + 30 , maxHeight)
        
    }
}
