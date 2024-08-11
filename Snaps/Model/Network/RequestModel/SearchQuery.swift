//
//  SearchQuery.swift
//  Snaps
//
//  Created by 조규연 on 8/10/24.
//

import Foundation

struct SearchQuery: Encodable {
    let query: String
    let page: Int
    let per_page: Int
    let orderBy: SortOrder.RawValue
    let client_id: String
}
