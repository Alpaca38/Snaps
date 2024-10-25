//
//  PhotoStatistics.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

struct Statistics: Decodable {
    let id: String
    let downloads: PhotoStatistics
    let views: PhotoStatistics
}

struct PhotoStatistics: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [ValueStatistics] // 30일간 통계
    
    var chartData: [ChartData] {
        return values.map { ChartData(date: $0.date, value: $0.value) }
    }
}

struct ValueStatistics: Decodable {
    let date: String
    let value: Int
}

struct ChartData: Identifiable {
    let id = UUID().uuidString
    let date: String
    let value: Int
}
