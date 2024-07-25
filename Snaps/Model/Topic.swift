//
//  Topic.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

protocol SectionType: Hashable {}
protocol SectionItem: Hashable {}

enum Section: CaseIterable, SectionType {
    case main
}

enum TopicSection: CaseIterable, SectionType {
    case first
    case second
    case third
    
    var headerTitle: String {
        switch self {
        case .first:
            return "골든 아워"
        case .second:
            return "비지니스 및 업무"
        case .third:
            return "건축 및 인테리어"
        }
    }
}

enum Topic: String, CaseIterable {
    case architecture = "architecture-interior"
    case goldenHour = "golden-hour"
    case wallPapers = "wallpapers"
    case nature = "nature"
    case threeD = "3d-renders"
    case travel = "travel"
    case texturesPatterns = "textures-patterns"
    case streetPhotography = "street-photography"
    case film = "film"
    case archival = "archival"
    case experimental = "experimental"
    case animals = "animals"
    case fashionBeauty = "fashion-beauty"
    case people = "people"
    case businessWork = "business-work"
    case foodDrink = "food-drink"
    
    var headerTitle: String {
        switch self {
        case .architecture:
            "건축 및 인테리어"
        case .goldenHour:
            "골든 아워"
        case .wallPapers:
            "배경 화면"
        case .nature:
            "자연"
        case .threeD:
            "3D 렌더링"
        case .travel:
            "여행하다"
        case .texturesPatterns:
            "텍스쳐 및 패턴"
        case .streetPhotography:
            "거리 사진"
        case .film:
            "필름"
        case .archival:
            "기록의"
        case .experimental:
            "실험적인"
        case .animals:
            "동물"
        case .fashionBeauty:
            "패션 및 뷰티"
        case .people:
            "사람"
        case .businessWork:
            "비즈니스 및 업무"
        case .foodDrink:
            "식음료"
        }
    }
}
