//
//  SearchColorQuery.swift
//  Snaps
//
//  Created by 조규연 on 8/10/24.
//

import Foundation

struct SearchColorQuery: Encodable {
    let query: String
    let page: Int
    let perPage: Int
    let orderBy: SortOrder.RawValue
    let color: PhotoColor.RawValue
    let client_id = APIKey.unsplashAccessKey
}
