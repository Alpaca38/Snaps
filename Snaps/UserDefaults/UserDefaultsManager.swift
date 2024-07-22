//
//  UserDefaultsManager.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

final class UserDefaultsManager {
    private init() { }

    @UserDefault(key: .isLogin, defaultValue: false, isCustomObject: false)
    static var isLogin: Bool
    
    @UserDefault(key: .user, defaultValue: User(image: Int.random(in: 0..<Image.Profile.allCases.count)), isCustomObject: true)
    static var user: User
}
