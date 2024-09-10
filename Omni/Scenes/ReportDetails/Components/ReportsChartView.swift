//
//  ReportsChartView.swift
//  Omni
//
//  Created by ahmetAltintop on 6.09.2024.
//

import UIKit
import DGCharts
import Charts

class ReportsChartView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private lazy var pieChart: PieChartView = {
        let chartView = PieChartView()
        chartView.holeColor = .clear
        chartView.transparentCircleColor = .clear
        chartView.legend.enabled = true
        chartView.legend.textColor = .black
        chartView.entryLabelColor = .clear
        chartView.holeRadiusPercent = 0.3
        chartView.drawEntryLabelsEnabled = false
        chartView.rotationEnabled = false
        chartView.legend.orientation = .vertical
        chartView.legend.horizontalAlignment = .left
        chartView.legend.verticalAlignment = .bottom
        chartView.legend.form = .circle
        chartView.legend.maxSizePercent = 1
        chartView.legend.yOffset = 0
        chartView.legend.xOffset = 0
        // asdlmaşlsmd
        // asöd a sd
        
        chartView.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 0)
        return chartView
    }()
    
    private func setupViews() {
        self.addSubview(self.pieChart)
        
        self.pieChart.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(24)
        }
    }
    
    // Rapor verilerine göre PieChart oluşturma
    func setPieChartData(reportData: [(String, Double)]) {
        var entries: [PieChartDataEntry] = []
        
        // Gönderilen verilerle doğrudan PieChartEntry oluşturuyoruz
        for (branch, revenue) in reportData {
            entries.append(PieChartDataEntry(value: revenue, label: branch)) // Label'a şube adını koyuyoruz
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.pastel() + [UIColor.systemGray]
        dataSet.sliceSpace = 2.0
        
        let pieData = PieChartData(dataSet: dataSet)
        pieData.setValueTextColor(.black)
        pieData.setValueFont(UIFont.systemFont(ofSize: 12))
        
        // Yüzde formatlayıcıyı ayarlıyoruz
        let percentFormatter = PercentValueFormatter()
        pieData.setValueFormatter(percentFormatter)
        
        self.pieChart.data = pieData
        self.pieChart.notifyDataSetChanged()
    }
    
}

// Yüzde formatını ayarlamak için ValueFormatter sınıfı
class PercentValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "%\(Int(value))" // Yüzde işareti ekleyip değeri tam sayıya çeviriyoruz
    }
}
