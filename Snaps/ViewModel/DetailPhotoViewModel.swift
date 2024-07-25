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
            self?.outputPhotoData.value = photoItem
        }
        
        inputLikedPhoto.bind { [weak self] likeItem in
            guard let likeItem else { return }
            self?.outputPhotoData.value = PhotoItem.toPhotoItem(likeItem: likeItem)
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
}
