//
//  AreaChart.swift
//  Snaps
//
//  Created by 조규연 on 7/27/24.
//

import Foundation
import SwiftUI
import Charts

struct AreaChart: View {
    var data: [ChartData] = []
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart(data) {
                AreaMark(
                    x: .value("", $0.date),
                    y: .value("", $0.value)
                )
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        } else {
            // Fallback on earlier versions
        }
    }
}
