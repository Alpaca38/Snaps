//
//  TopicPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation

final class TopicPhotoViewModel {
    var outputFirstSectionData = Observable<[PhotoItem]>([])
    var outputSecondSectionData = Observable<[PhotoItem]>([])
    var outputThirdSectonData = Observable<[PhotoItem]>([])
    var outputNetworkError = Observable<APIError?>(nil)
    
    var inputViewDidLoadTrigger = Observable<[String]?>(nil)
    var randomTopicList = Topic.allCases.shuffled().map { $0.rawValue }
    
    init() {
        inputViewDidLoadTrigger.bind(false) { [weak self] topicList in
            guard let topicList else { return }
            self?.getTopicPhoto(topicList: topicList)
        }
    }
}

private extension TopicPhotoViewModel {
    func getTopicPhoto(topicList: [String]) {
        getFirstTopicPhoto(topicList: topicList)
        getSecondTopicPhoto(topicList: topicList)
        getThirdTopicPhoto(topicList: topicList)
    }
    
    func getFirstTopicPhoto(topicList: [String]) {
        NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[0]), responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputFirstSectionData.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
    
    func getSecondTopicPhoto(topicList: [String]) {
        NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[1]), responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputSecondSectionData.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
    
    func getThirdTopicPhoto(topicList: [String]) {
        NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[2]), responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputThirdSectonData.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
}
