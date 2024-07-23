//
//  TopicPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation

final class TopicPhotoViewModel {
    private(set) var outputGoldenHour = Observable<[PhotoItem]>([])
    private(set) var outputBusiness = Observable<[PhotoItem]>([])
    private(set) var outputArchitecture = Observable<[PhotoItem]>([])
    private(set) var outputNetworkError = Observable<APIError?>(nil)
    
    var inputViewDidLoadTrigger = Observable<Void?>(nil)
    
    init() {
        inputViewDidLoadTrigger.bind(false) { [weak self] _ in
            self?.getTopicPhoto()
        }
    }
}

private extension TopicPhotoViewModel {
    func getTopicPhoto() {
        getGoldenHourPhoto()
        getBusinessPhoto()
        getArchitecturePhoto()
    }
    
    func getGoldenHourPhoto() {
        NetworkManager.shared.getPhotoData(api: .goldenHour, responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputGoldenHour.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
    
    func getBusinessPhoto() {
        NetworkManager.shared.getPhotoData(api: .businessAndWork, responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputBusiness.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
    
    func getArchitecturePhoto() {
        NetworkManager.shared.getPhotoData(api: .architectureAndInterior, responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputArchitecture.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
}
