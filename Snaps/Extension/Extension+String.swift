//
//  Extension+Date.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

extension String {
    func formattedToKoreanDate() -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: self) else { return nil }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy년 M월 d일 '게시됨'"
        
        return outputDateFormatter.string(from: date)
    }
}
