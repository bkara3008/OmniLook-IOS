//
//  FilterViewController.swift
//  Omni
//
//  Created by ahmetAltintop on 8.08.2024.
//

import UIKit

class FilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareViews()
        self.setupPanGesture()
        self.reloadDateAndFirmInfos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Internal -
    
    //MARK: - Public -
    var onFilterApply: (([Int], String, String,HomeModels.TempReportTypes) -> Void)?
    
    var firmList: [HomeModels.FirmListModel] = []
    var firmGroupList: [HomeModels.FirmGroupListModel] = []
    var reports: [ReportModels.BestSellingProductModel] = []
    
    var selectedStartDate: Date = Date()
    var selectedEndDate: Date = Date()
    var reportType: HomeModels.TempReportTypes = .acikCekler
    
    // MARK: - Private -
    private var startDate: String?
    private var endDate: String?
    
    private var selectedRows: [[Bool]] = []
    private var expandedSections: [Bool] = []
    
    private let panModalGesture = UIPanGestureRecognizer()
    
    private lazy var containerStackView: UIStackView = {
        let stackView =  UIStackView(arrangedSubviews: [self.dateHeaderView,
                                                        self.datePickerView,
                                                        self.firmHeaderView,
                                                        self.tableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private lazy var dateHeaderView: FilterHeaderView = {
        let view = FilterHeaderView()
        view.configure(title: "Date_Range".translated())
        return view
    }()
    
    private lazy var firmHeaderView: FilterHeaderView = {
        let view = FilterHeaderView()
        view.configure(title: "Firms".translated())
        return view
    }()
    
    private lazy var datePickerView: DatePickerView = {
        let view = DatePickerView()
        view.backgroundColor = .clear
        view.configure(firstDate: self.selectedStartDate, lastDate: self.selectedEndDate)
        
        view.onDateSelected = { [weak self] startDateString, endDateString in
            guard let self = self else { return }
                
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            if let startDate = formatter.date(from: startDateString) {
                self.startDate = startDateString
                self.selectedStartDate = startDate
            }
                
            if let endDate = formatter.date(from: endDateString) {
                self.endDate = endDateString
                self.selectedEndDate = endDate
            }
        }
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterTableViewCell.self,
                           forCellReuseIdentifier: FilterTableViewCell.identifier)
        tableView.register(FilterTableViewSectionView.self, forHeaderFooterViewReuseIdentifier: FilterTableViewSectionView.identifier)
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        return tableView
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter_".translated(), for: .normal)
        button.backgroundColor = .appGreen
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.addTarget(self, action: #selector(self.filterButton_Tapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()

    private func prepareViews() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 16
        
        self.view.addSubview(self.topLineView)
        self.view.addSubview(self.containerStackView)
        self.view.addSubview(self.filterButton)
        
        self.topLineView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(32)
        }
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.bottom.equalTo(self.filterButton.snp.top).offset(-12)
        }
        
        self.filterButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        // TableView için minimum yükseklik veya sabit yükseklik
        self.tableView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(200) // Minumum bir yükseklik belirleyin   
        }
        
        self.expandedSections = Array(repeating: true, count: self.firmGroupList.count)
        self.selectedRows = firmGroupList.map { group in
              return Array(repeating: true, count: firmList.filter { $0.firmaGrupID == group.firmaGrupID }.count)
          }
    }
    
    private func reloadDateAndFirmInfos() {
            
        let savedFirmIDs = self.getSelectedFirmIDsFromDefaults()
        let (savedStartDate, savedEndDate) = getSelectedDatesFromDefaults()
        
        // Firma seçimlerini ayarla
        for sectionIndex in 0..<firmGroupList.count {
            let firmsInSection = firmList.filter { $0.firmaGrupID == firmGroupList[sectionIndex].firmaGrupID }
            
            for rowIndex in 0..<firmsInSection.count {
                self.selectedRows[sectionIndex][rowIndex] = savedFirmIDs.contains(firmsInSection[rowIndex].firmaID)
            }
        }
        
        self.selectedStartDate = savedStartDate
        self.selectedEndDate = savedEndDate
        
        datePickerView.configure(firstDate: savedStartDate, lastDate: savedEndDate)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func setupPanGesture() {
        self.panModalGesture.addTarget(self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(self.panModalGesture)
    }
    
//    private func showDateSelectionView() {
//        self.view.addSubview(self.dateSelectionView)
//        self.dateSelectionView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(300) // Gerekli yüksekliği ayarlayın
//        }
//    }
    
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
    
    @objc
    private func filterButton_Tapped() {
        let selectedFirmIDs = self.getSelectedFirmIDs()
          
        saveSelectedFirmIDs(selectedFirmIDs)
        saveSelectedDates(startDate: self.selectedStartDate, endDate: self.selectedEndDate)
        
        onFilterApply?(selectedFirmIDs, self.formatDate(self.selectedStartDate), self.formatDate(self.selectedEndDate), self.reportType)
                        
        self.dismiss(animated: true)
    }
    
}

    //MARK: - ModalContentHeightCalculable -

extension FilterViewController: ModalContentHeightCalculable {
    func calculateContentHeight() -> CGFloat {
        view.layoutIfNeeded()
        
        var totalHeight: CGFloat = 0
        
        let stackViewSubviews = containerStackView.arrangedSubviews
        for subview in stackViewSubviews {
            totalHeight += subview.frame.height
        }
        
        let numberOfSections = tableView.numberOfSections
        for section in 0..<numberOfSections {
            
            totalHeight += tableView.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0
            
            let numberOfRows = tableView.numberOfRows(inSection: section)
            for row in 0..<numberOfRows {
                totalHeight += tableView.delegate?.tableView?(tableView, heightForRowAt: IndexPath(row: row, section: section)) ?? 0
            }
        }
        totalHeight += filterButton.frame.height
        view.layoutIfNeeded()
        
        let maxHeight = UIScreen.main.bounds.height * 0.85
        return min(totalHeight, maxHeight)
    }
    
}

    //MARK: - UITableViewDataSource -

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expandedSections[section] ? self.firmList.filter { $0.firmaGrupID == firmGroupList[section].firmaGrupID }.count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.firmGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        
        let firmListForSection = self.firmList.filter { $0.firmaGrupID == firmGroupList[indexPath.section].firmaGrupID }
        let isChecked = selectedRows[indexPath.section][indexPath.row]
        cell.setupCell(branchName: firmListForSection[indexPath.row].firmaAdi,isChecked: isChecked,indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

    //MARK: - UITableViewDelegate -

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterTableViewSectionView.identifier) as? FilterTableViewSectionView else {
            return nil
        }
            
        let groupName = firmGroupList[section].grupAdi
        let isChecked = selectedRows[section].allSatisfy { $0 }
            
        headerView.configure(title: groupName, isChecked: isChecked, isExpand: expandedSections[section])
            
        headerView.onExpandButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.expandedSections[section].toggle()
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
            
        headerView.onSelectionButtonTapped = { [weak self] in
            guard let self = self else { return }
            let isChecked = !self.selectedRows[section].allSatisfy { $0 }
            self.updateSelectionForSection(section, isChecked: isChecked)
            
            // Seçili olan firm ID'lerini al
            let selectedFirmIDs = self.getSelectedFirmIDs()
            print("Seçili Firm ID'leri: \(selectedFirmIDs)")
        }
        return headerView
    }
}

    //MARK: - FilterTableViewCellDelegate  -

extension FilterViewController: FilterTableViewCellDelegate {
    func didToggleCheckbox(at indexPath: IndexPath) {
        toggleSelectionForRow(at: indexPath)
         
         let section = indexPath.section
         let isSectionChecked = selectedRows[section].allSatisfy { $0 }
         
         // Section başlığındaki seçim butonunu güncelle
         if let headerView = tableView.headerView(forSection: section) as? FilterTableViewSectionView {
             headerView.configure(title: firmGroupList[section].grupAdi, isChecked: isSectionChecked, isExpand: expandedSections[section])
         }
         
         // Seçili olan firm ID'lerini al
         let selectedFirmIDs = getSelectedFirmIDs()
         print("Seçili Firm ID'leri: \(selectedFirmIDs)")
    }
}

extension FilterViewController {

    func getSelectedFirmIDs() -> [Int] {
        var selectedFirmIDs: [Int] = []
        
        for sectionIndex in 0..<selectedRows.count {
            let firmsInSection = firmList.filter { $0.firmaGrupID == firmGroupList[sectionIndex].firmaGrupID }
            
            for (rowIndex, isSelected) in selectedRows[sectionIndex].enumerated() {
                if isSelected {
                    let firmID = firmsInSection[rowIndex].firmaID
                    selectedFirmIDs.append(firmID)
                }
            }
        }
        
        return selectedFirmIDs
    }
    
    func updateSelectionForSection(_ section: Int, isChecked: Bool) {
        selectedRows[section] = Array(repeating: isChecked, count: selectedRows[section].count)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func toggleSelectionForRow(at indexPath: IndexPath) {
        selectedRows[indexPath.section][indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

    //MARK: - Save&Get Date&FirmID Infos  -

extension FilterViewController {
    
    private func saveSelectedFirmIDs(_ firmIDs: [Int]) {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.savedFirmIDsKey)
        UserDefaults.standard.set(firmIDs, forKey: Constants.UserDefaults.savedFirmIDsKey)
    }
    
    private func getSelectedFirmIDsFromDefaults() -> [Int] {
        return UserDefaults.standard.array(forKey: Constants.UserDefaults.savedFirmIDsKey) as? [Int] ?? []
    }
    
    private func saveSelectedDates(startDate: Date, endDate: Date) {
        UserDefaults.standard.set(startDate, forKey: Constants.UserDefaults.savedStartDateKey)
        UserDefaults.standard.set(endDate, forKey: Constants.UserDefaults.savedEndDateKey)
    }
       
    private func getSelectedDatesFromDefaults() -> (Date, Date) {
        let startDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedStartDateKey) as? Date ?? Date()
        let endDate = UserDefaults.standard.object(forKey: Constants.UserDefaults.savedEndDateKey) as? Date ?? Date()
        return (startDate, endDate)
    }
}
