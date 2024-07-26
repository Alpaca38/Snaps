//
//  PhotoColor.swift
//  Snaps
//
//  Created by 조규연 on 7/26/24.
//

import UIKit

enum PhotoColor: String, CaseIterable, SectionItem {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
    
    var imageColor: UIColor {
        switch self {
        case .black:
                .black
        case .white:
                .white
        case .yellow:
                .yellow
        case .red:
                .red
        case .purple:
                .purple
        case .green:
                .gray
        case .blue:
                .blue
        }
    }
    
    var colorTitle: String {
        switch self {
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .green:
            "그린"
        case .blue:
            "블루"
        }
    }
}

struct PhotoColorItem: Hashable, SectionItem {
    let photoColor: PhotoColor
    var isSelected = false
}
