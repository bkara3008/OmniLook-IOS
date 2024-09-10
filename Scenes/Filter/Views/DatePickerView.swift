//
//  DatePickerView.swift
//  Omni
//
//  Created by ahmetAltintop on 8.08.2024.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func didtapDatePicker()
}

class DatePickerView: UIView {
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepareView()
        self.setupDatePickerTargets()
        self.updateSegmentedControlFont()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal -
    
    func configure(firstDate: Date, lastDate: Date) {
        let selectedLanguage = UserDefaults.standard.string(forKey: Constants.UserDefaults.SelectedLanguageKey)
        
        if selectedLanguage == "Turkish" {
            self.startDateView.locale = Locale(identifier: "tr_TR")
            self.endDateView.locale = Locale(identifier: "tr_TR")
        } else if selectedLanguage == "English" {
            self.startDateView.locale = Locale(identifier: "en_TR")
            self.endDateView.locale = Locale(identifier: "en_TR")
        }
        
        self.startDateView.date = firstDate
        self.endDateView.date = lastDate
    }
    
    var onDateSelected: ((String, String) -> Void)?
    weak var delegate: DatePickerViewDelegate?
    
    // MARK: - Private -
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.startDateStackView,
                                                       self.endDateStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var startDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.startTitle,
                                                       self.startDateView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var endDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.endTitle,
                                                       self.endDateView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var startDateView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(self.startDateValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    lazy var endDateView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(self.endDateValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var startTitle: UILabel = {
        let label = UILabel()
        label.text = "StartDate".translated()
        label.textAlignment  = .center
        label.textColor = .appBlue
        label.font = UIFont(name: "Montserrat-SemiBold",
                            size: 14)
        return label
    }()
    
    private lazy var endTitle: UILabel = {
        let label = UILabel()
        label.text = "EndDate".translated()
        label.textAlignment  = .center
        label.textColor = .appBlue
        label.font = UIFont(name: "Montserrat-SemiBold",
                            size: 14)
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Today".translated(), "Yesterday".translated(), "This_Week".translated(), "Last_Week".translated(), "This_Month".translated(), "Last_Month".translated()]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    

    private func prepareView() {
        self.addSubview(self.containerStackView)
        self.addSubview(self.segmentedControl)
        self.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        self.containerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview()
        }
        self.segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.height.equalTo(36)
            make.top.equalTo(self.containerStackView.snp.bottom).offset(6)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func setupDatePickerTargets() {
        self.startDateView.addTarget(self, action: #selector(self.dateValueChanged), for: .valueChanged)
        self.endDateView.addTarget(self, action: #selector(self.dateValueChanged), for: .valueChanged)
     }
    
    private func updateSegmentedControlFont() {
        let normalFont = UIFont(name: "Montserrat-Regular", size: 9)
        let selectedFont = UIFont(name: "Montserrat-SemiBold", size: 10)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: normalFont ?? UIFont.systemFont(ofSize: 10, weight: .regular),
            .foregroundColor: UIColor.black
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: selectedFont ?? UIFont.systemFont(ofSize: 10, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
     
    //MARK: - Action -
    
    @objc private func startDateValueChanged() {
        if startDateView.date > endDateView.date {
            endDateView.date = startDateView.date
        }
        self.dateValueChanged()
    }
    
    @objc private func endDateValueChanged() {
        if endDateView.date < startDateView.date {
            startDateView.date = endDateView.date
        }
        self.dateValueChanged()
    }
    
    @objc private func dateValueChanged() {
        let startDateString = formatDate(startDateView.date)
        let endDateString = formatDate(endDateView.date)
        
        // Tarihleri closure ile iletir
        self.onDateSelected?(startDateString, endDateString)
    }
    
    @objc private func segmentedControlValueChanged() {
        let calendar = Calendar.current
        let today = Date()
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: // Bugün
            self.startDateView.date = Date()
            self.endDateView.date = Date()
        case 1: // Dün
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            self.startDateView.date = yesterday
            self.endDateView.date = yesterday
        case 2: // Bu Hafta
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            self.startDateView.date = startOfWeek
            self.endDateView.date = today
        case 3: // Geçen Ay
            let startOfLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!)!
            let endOfLastWeek = calendar.date(byAdding: .day, value: 6, to: startOfLastWeek)!
            self.startDateView.date = startOfLastWeek
            self.endDateView.date = endOfLastWeek
        case 4: // Bu Ay
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
            self.startDateView.date = startOfMonth
            self.endDateView.date = today
        case 5: // Geçen Ay
            let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: calendar.date(from: calendar.dateComponents([.year, .month], from: today))!)!
            let range = calendar.range(of: .day, in: .month, for: startOfLastMonth)!
            let endOfLastMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfLastMonth)!
            self.startDateView.date = startOfLastMonth
            self.endDateView.date = endOfLastMonth
        default:
            break
        }
        self.updateSegmentedControlFont()
        
        self.dateValueChanged()
    }
}
