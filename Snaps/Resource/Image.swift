//
//  Image.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

enum Image {
    static let camera = UIImage(systemName: "camera.fill")
    static let launchTitle = UIImage(named: "snaps_image")
    static let lauchImage = UIImage(named: "launchImage")
    static let likeCircleInactive = UIImage(named: "like_circle_inactive")
    static let likeCircle = UIImage(named: "like_circle")
    static let likeInactive = UIImage(named: "like_inactive")
    static let like = UIImage(named: "like")
    static let sort = UIImage(named: "sort")
    static let tabLikeInactive = UIImage(named: "tab_like_inactive")
    static let tabLike = UIImage(named: "tab_like")
    static let tabRandomInactive = UIImage(named: "tab_random_inactive")
    static let tabRandom = UIImage(named: "tab_random")
    static let tabSearchInActive = UIImage(named: "tab_search_inactive")
    static let tabSearch = UIImage(named: "tab_search")
    static let tabTrend = UIImage(named: "tab_trend")
    static let tabTrendInactive = UIImage(named: "tap_trend_inactvie")
    
    enum Profile: Int, CaseIterable {
        case one, two, three, four, five, six, seven, eight, nine, ten, eleven, tweleve
        
        var profileImage: String {
            switch self {
            case .one:
                return "profile_0"
            case .two:
                return "profile_1"
            case .three:
                return "profile_2"
            case .four:
                return "profile_3"
            case .five:
                return "profile_4"
            case .six:
                return "profile_5"
            case .seven:
                return "profile_6"
            case .eight:
                return "profile_7"
            case .nine:
                return "profile_8"
            case .ten:
                return "profile_9"
            case .eleven:
                return "profile_10"
            case .tweleve:
                return "profile_11"
            }
        }
    }
    
    enum Border {
        static let active: CGFloat = 3
        static let inActive: CGFloat = 1
    }
    
    enum Alpha {
        static let active: CGFloat = 1
        static let inActive: CGFloat = 0.5
    }
    
    enum Size {
        static let bigProfile: CGFloat = 100
        static let smallProfile: CGFloat = 80
        static let camera: CGFloat = 25
    }
}
