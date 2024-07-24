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
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var imageURL: String
    @Persisted var regDate: Date
    
    convenience init(id: String, width: Int, height: Int, imageURL: String, isLiked: Bool, regDate: Date) {
        self.init()
        self.id = id
        self.width = width
        self.height = height
        self.imageURL = imageURL
        self.regDate = Date()
    }
    
    convenience init(from photoItem: PhotoItem) {
        self.init()
        self.id = photoItem.id
        self.width = photoItem.width
        self.height = photoItem.height
        self.imageURL = photoItem.urls.small
        self.regDate = Date()
    }
}
