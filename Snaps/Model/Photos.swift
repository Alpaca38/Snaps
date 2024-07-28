//
//  Photos.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation
import RealmSwift

struct Photos: Decodable, Hashable {
    let results: [PhotoItem]
}

struct PhotoItem: Decodable, Hashable, Identifiable, SectionItem {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: Link
    let likes: Int
    let user: PhotoGrapher
    let color: String
    
    var koreanDate: String {
        guard let koreanDate = created_at.formattedToKoreanDate() else { return created_at }
        return koreanDate
    }
    
    var size: String {
        return "\(width) x \(height)"
    }
}

struct Link: Decodable, Hashable {
    let raw: String
    let small: String
}

struct PhotoGrapher: Decodable, Hashable {
    let id: String
    let name: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable, Hashable {
    let medium: String
}

enum SortOrder: String {
    case relevant
    case latest
}
