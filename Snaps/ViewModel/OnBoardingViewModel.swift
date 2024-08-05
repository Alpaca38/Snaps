//
//  OnBoardingViewModel.swift
//  Snaps
//
//  Created by 조규연 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class OnBoardingViewModel {
    func transform(input: Input) -> Output {
        return Output(startTap: input.startTap)
    }
}

extension OnBoardingViewModel {
    struct Input {
        let startTap: ControlEvent<Void>
    }
    
    struct Output {
        let startTap: ControlEvent<Void>
    }
}
