//
//  Observable.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

final class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ excuteInit: Bool = true, closure: @escaping (T) -> Void) {
        if excuteInit {
            closure(value)
        }
        self.closure = closure
    }
}
