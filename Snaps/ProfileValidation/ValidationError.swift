//
//  ValidationError.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

enum ValidationError: Error {
    case includeSpecial
    case includeInt
    case isNotValidCount
}
