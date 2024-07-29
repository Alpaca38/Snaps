//
//  TopicPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation

final class TopicPhotoViewModel {
    private var lastRefreshTime: Date?
    var isRefreshing = Observable<Void?>(nil)
    var refreshCompleted = Observable<Bool?>(nil)
    
    var outputFirstSectionData = Observable<[PhotoItem]>([])
    var outputSecondSectionData = Observable<[PhotoItem]>([])
    var outputThirdSectonData = Observable<[PhotoItem]>([])
    var outputNetworkError = Observable<APIError?>(nil)
    var outputUpdateSnapshot = Observable<Void?>(nil)
    
    var inputTopic = Observable<[String]?>(nil)
    var inputRefresh = Observable<Void?>(nil)
    
    init() {
        transform()
    }
}

private extension TopicPhotoViewModel {
    func transform() {
        inputTopic.bind(false) { [weak self] topicList in
            guard let topicList else { return }
            self?.getTopicPhoto(topicList: topicList)
        }
        
        inputRefresh.bind(false) { [weak self] _ in
            self?.handleRefreshControl()
        }
    }
    
    func getTopicPhoto(topicList: [String]) {
        let waitGroup = DispatchGroup()
        waitGroup.enter()
        DispatchQueue.global().async(group: waitGroup) { [weak self] in
            NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[0]), responseType: [PhotoItem].self) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.outputFirstSectionData.value = success
                case .failure(let failure):
                    self?.outputNetworkError.value = failure
                }
                waitGroup.leave()
            }
        }
        waitGroup.enter()
        DispatchQueue.global().async(group: waitGroup) { [weak self] in
            NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[1]), responseType: [PhotoItem].self) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.outputSecondSectionData.value = success
                case .failure(let failure):
                    self?.outputNetworkError.value = failure
                }
                waitGroup.leave()
            }
        }
        waitGroup.enter()
        DispatchQueue.global().async(group: waitGroup) { [weak self] in
            NetworkManager.shared.getPhotoData(api: .topic(topicID: topicList[2]), responseType: [PhotoItem].self) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.outputThirdSectonData.value = success
                case .failure(let failure):
                    self?.outputNetworkError.value = failure
                }
                waitGroup.leave()
            }
        }
        waitGroup.notify(queue: .main) { [weak self] in
            self?.outputUpdateSnapshot.value = ()
        }
    }
    
    func handleRefreshControl() {
        let currentTime = Date()
        
        if let lastTime = lastRefreshTime, currentTime.timeIntervalSince(lastTime) < 60 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.refreshCompleted.value = false
            }
        } else {
            lastRefreshTime = currentTime
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
                self?.isRefreshing.value = ()
                self?.refreshCompleted.value = true
            }
        }
    }
}
