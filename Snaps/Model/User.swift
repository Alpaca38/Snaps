//
//  User.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

struct User: Codable {
    var nickname: String = ""
    var image: Image.Profile.RawValue // Int
}
