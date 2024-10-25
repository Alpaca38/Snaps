//
//  DetailPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

final class DetailPhotoViewModel {
    private let repository = try? RealmRepository<LikeItems>()
    
    var outputPhotoData = CustomObservable<PhotoItem?>(nil)
    var outputLikedPhotoData = CustomObservable<PhotoItem?>(nil)
    var outputSetLike = CustomObservable<Bool?>(nil)
    var outputStatistics = CustomObservable<Statistics?>(nil)
    var outputStatisticsError = CustomObservable<APIError?>(nil)
    
    var inputSelectedPhoto = CustomObservable<PhotoItem?>(nil)
    var inputLikedPhoto = CustomObservable<PhotoItem?>(nil)
    var inputLikeButtonTapped = CustomObservable<(Data?, Data?, PhotoItem?)>((nil,nil,nil))
    var inputLikedButtonTapped = CustomObservable<LikeItems?>(nil)
    
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
        
        inputLikedPhoto.bind(false) { [weak self] likedItem in
            guard let likedItem else { return }
            self?.outputLikedPhotoData.value = likedItem
            self?.getStatistics(imageID: likedItem.id)
        }
        
        inputLikeButtonTapped.bind { [weak self] (photoData, profileData, photoItem) in
            guard let photoData, let profileData, let photoItem else { return }
            if UserDefaultsManager.likeList.contains(photoItem.id) {
                UserDefaultsManager.likeList.remove(photoItem.id)
                
                NotificationCenter.default.post(name: .likeItemWillBeRemoved, object: LikeItems(from: photoItem))
                
                guard let deleteItem = self?.repository?.fetchItemFromProduct(id: photoItem.id) else { return }
                self?.repository?.deleteItem(data: deleteItem)
                
                self?.outputSetLike.value = false
            } else {
                UserDefaultsManager.likeList.insert(photoItem.id)
                
                FileUtility.shared.saveImageToDocument(data: photoData, filename: photoItem.id)
                FileUtility.shared.saveImageToDocument(data: profileData, filename: photoItem.user.id)
                
                self?.repository?.createItem(data: LikeItems(from: photoItem))
                
                self?.outputSetLike.value = true
            }
        }
        
        inputLikedButtonTapped.bind { [weak self] likedItem in
            guard let likedItem else { return }
            if UserDefaultsManager.likeList.contains(likedItem.id) {
                guard let deleteItem = self?.repository?.fetchItemFromProduct(id: likedItem.id) else { return }
                NotificationCenter.default.post(name: .likeItemWillBeRemoved, object: likedItem)
                self?.repository?.deleteItem(data: deleteItem)
                self?.outputSetLike.value = false
            } else {
                self?.repository?.createItem(data: likedItem)
                self?.outputSetLike.value = true
            }
        }
    }
    
    func getStatistics(imageID: String) {
        NetworkManager.shared.getStatistics(imageID: imageID) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputStatistics.value = success
            case .failure(let failure):
                self?.outputStatisticsError.value = failure
            }
        }
    }
}
