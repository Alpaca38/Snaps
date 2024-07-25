//
//  RealmModel.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import Foundation
import RealmSwift

final class LikeItems: Object, SectionItem {
    @Persisted(primaryKey: true) var identifier: ObjectId
    @Persisted var id: String
    @Persisted var created_at: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var rawImageURL: String
    @Persisted var smallImageURL: String
    @Persisted var regDate: Date
    @Persisted var likes: Int
    @Persisted var photoGrapherName: String
    @Persisted var photoGrapherProfileImage: String
    
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
        self.photoGrapherName = photoItem.user.name
        self.photoGrapherProfileImage = photoItem.user.profileImage.medium
    }
}
