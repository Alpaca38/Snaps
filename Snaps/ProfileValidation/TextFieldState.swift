//
//  TextFieldSate.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

enum TextFieldState {
    static let specialCharacter = "닉네임에 @,#,$,% 는 포함할 수 없어요."
    static let number = "닉네임에 숫자는 포함할 수 없어요."
    static let count = "2글자 이상 10글자 미만으로 설정해주세요."
    static let valid = "사용할 수 있는 닉네임이에요."
}
