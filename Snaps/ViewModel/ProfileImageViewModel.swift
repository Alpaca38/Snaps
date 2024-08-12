//
//  ProfileImageViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

final class ProfileImageViewModel {
    var outputImage: CustomObservable<String?> = CustomObservable(nil)
    
    var inputSelectedIndex: CustomObservable<Int> = CustomObservable(UserDefaultsManager.user.image)
    
    init() {
        inputSelectedIndex.bind { [weak self] index in
            self?.outputImage.value = Image.Profile.allCases[index].profileImage
        }
    }
}
