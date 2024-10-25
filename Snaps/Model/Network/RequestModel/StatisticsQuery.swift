//
//  StatisticsQuery.swift
//  Snaps
//
//  Created by 조규연 on 8/10/24.
//

import Foundation

struct StatisticsQuery: Encodable {
    let imageID: String
    let client_id = APIKey.unsplashAccessKey
}
