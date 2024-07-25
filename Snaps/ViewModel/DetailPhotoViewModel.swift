//
//  DetailPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

final class DetailPhotoViewModel {
    private let repository = LikeRepository()
    
    var outputPhotoData = Observable<PhotoItem?>(nil)
    var outputSetLike = Observable<Bool?>(nil)
    var outputStatistics = Observable<Statistics?>(nil)
    var outputStatisticsError = Observable<APIError?>(nil)
    
    var inputSelectedPhoto = Observable<PhotoItem?>(nil)
    var inputLikedPhoto = Observable<LikeItems?>(nil)
    var inputLikeButtonTapped = Observable<PhotoItem?>(nil)
    
    init() {
        transform()
    }
}

private extension DetailPhotoViewModel {
    func transform() {
        inputSelectedPhoto.bind(false) { [weak self] photoItem in
            guard let photoItem else { return }
            self?.outputPhotoData.value = photoItem
            self?.getStatistics(imageID: photoItem.id)
        }
        
        inputLikedPhoto.bind { [weak self] likeItem in
            guard let likeItem else { return }
            self?.outputPhotoData.value = PhotoItem.toPhotoItem(likeItem: likeItem)
            self?.getStatistics(imageID: PhotoItem.toPhotoItem(likeItem: likeItem).id)
        }
        
        inputLikeButtonTapped.bind { [weak self] photoItem in
            guard let photoItem else { return }
            if UserDefaultsManager.likeList.contains(photoItem.id) {
                UserDefaultsManager.likeList.remove(photoItem.id)
                NotificationCenter.default.post(name: .likeItemWillBeRemoved, object: LikeItems(from: photoItem))
                guard let deleteItem = self?.repository.fetchItemFromProduct(id: photoItem.id) else { return }
                self?.repository.deleteItem(data: deleteItem)
                self?.outputSetLike.value = false
            } else {
                UserDefaultsManager.likeList.insert(photoItem.id)
                self?.repository.createItem(data: LikeItems(from: photoItem))
                self?.outputSetLike.value = true
            }
        }
    }
    
    func getStatistics(imageID: String) {
        NetworkManager.shared.getPhotoData(api: .statistics(imageID: imageID), responseType: Statistics.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputStatistics.value = success
            case .failure(let failure):
                self?.outputStatisticsError.value = failure
            }
        }
    }
}
