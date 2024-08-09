//
//  Extension+Date.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

final class DateFormatManager {
    private init() { }
    static let shared = DateFormatManager()
    
    private let formatter = ISO8601DateFormatter()
    private let outputDateFormatter = DateFormatter()
    
    func formattedToKoreanDate(dateString: String) -> String? {
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: dateString) else { return nil }
        
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy년 M월 d일 '게시됨'"
        
        return outputDateFormatter.string(from: date)
    }
}
