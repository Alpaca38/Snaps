//
//  RandomQuery.swift
//  Snaps
//
//  Created by 조규연 on 8/10/24.
//

import Foundation

struct RandomQuery: Encodable {
    let count: Int
    let client_id = APIKey.unsplashAccessKey
}
