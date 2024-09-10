//
//  RevenueChartView.swift
//  Omni
//
//  Created by ahmetAltintop on 23.08.2024.
//

import UIKit
import Charts
import DGCharts

class RevenueChartView: UIView {
    var currency: HomeModels.Currencies = .def
    
    private let lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.isUserInteractionEnabled = false
        chartView.backgroundColor = .clear
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(7, force: false)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelFont = .systemFont(ofSize: 8)
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.labelRotationAngle = -45
        chartView.leftAxis.labelTextColor = .white
        chartView.animate(xAxisDuration: 1.7)
        chartView.legend.enabled = false
        
        chartView.extraBottomOffset = chartView.xAxis.labelRotatedHeight + 20
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.currency = self.getAppCurrency()
        
        self.backgroundColor = .clear
        self.addSubview(lineChartView)
        
        self.lineChartView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4)
        }
        self.lineChartView.extraRightOffset = 20
        self.lineChartView.zoomOut()
    }
    
    func setData(dates: [String], values: [Double], currency: String) {
        var entries: [ChartDataEntry] = []
        
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.valueTextColor = .white
        dataSet.lineWidth = 2.0
        dataSet.circleColors = [NSUIColor.systemBlue]
        dataSet.circleRadius = 4.0
        dataSet.mode = .cubicBezier
        dataSet.valueFont = .systemFont(ofSize: 6)

        // Burada formatlayıcıyı kullanıyoruz
        dataSet.valueFormatter = CurrencyValueFormatter(currencySymbol: currency)

        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        
        // X ekseni etiketlerini güncelleme
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        lineChartView.xAxis.granularity = 1
    }
    
}

class CurrencyValueFormatter: NSObject, ValueFormatter {
    private let currencySymbol: String

    init(currencySymbol: String) {
        self.currencySymbol = currencySymbol
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencyDecimalSeparator = ","
        numberFormatter.currencyGroupingSeparator = "."
        numberFormatter.positiveSuffix = " \(currencySymbol)" // Sembolü sona ekleyin
        
        
        if let formattedValue = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedValue
        }
        return "\(value) \(currencySymbol)"
    }
}
