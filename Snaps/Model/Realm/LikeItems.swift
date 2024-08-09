//
//  RealmModel.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import Foundation
import RealmSwift

final class LikeItems: Object, SectionItem {
    @Persisted(primaryKey: true) var id: String
    @Persisted var created_at: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var rawImageURL: String
    @Persisted var smallImageURL: String
    @Persisted var regDate: Date
    @Persisted var likes: Int
    @Persisted var photoGrapherID: String
    @Persisted var photoGrapherName: String
    @Persisted var photoGrapherProfileImage: String
    @Persisted var color: String
    
    var koreanDate: String {
        guard let koreanDate = DateFormatManager.shared.formattedToKoreanDate(dateString: created_at) else { return created_at }
        return koreanDate
    }
    
    var size: String {
        return "\(width) x \(height)"
    }
    
    convenience init(from photoItem: PhotoItem) {
        self.init()
        self.id = photoItem.id
        self.created_at = photoItem.created_at
        self.width = photoItem.width
        self.height = photoItem.height
        self.rawImageURL = photoItem.urls.raw
        self.smallImageURL = photoItem.urls.small
        self.regDate = Date()
        self.likes = photoItem.likes
        self.photoGrapherID = photoItem.user.id
        self.photoGrapherName = photoItem.user.name
        self.photoGrapherProfileImage = photoItem.user.profileImage.medium
        self.color = photoItem.color
    }
}
