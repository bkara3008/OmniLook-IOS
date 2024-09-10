//
//  ReportDetailsModel.swift
//  Omni
//
//  Created by ahmetAltintop on 15.07.2024.
//

import Foundation

protocol Report {
    var title: String { get }
    var headers: [String] { get }
    var data: [[String]] { get }
}

enum ReportDetails {
    
    enum BottomButtonTypes: String {
        case home
        case report
        case filter
    }
    
    enum DisplayTypes {
        case pieChart
        case list
    }
    
}


