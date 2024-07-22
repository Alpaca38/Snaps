//
//  ReuseIdentifier.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension NSObject: ReuseIdentifier { }
