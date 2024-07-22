//
//  ValidationError.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

enum NicknameValidationError: Error {
    case includeSpecial
    case includeInt
    case isNotValidCount
}

enum MBTIValidationError: Error {
    case isNotValidCount
}
