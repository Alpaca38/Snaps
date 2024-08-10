//
//  RandomPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import Foundation

final class RandomPhotoViewModel {
    private let repository = try? RealmRepository<LikeItems>()
    
    var outputList = Observable<[PhotoItem]>([])
    var outputNetworkError = Observable<APIError?>(nil)
    
    var inputViewDidLoadTrigger = Observable<Void?>(nil)
    var inputLikeItemRemove = Observable<LikeItems?>(nil)
    var inputLikeItemAdd = Observable<LikeItems?>(nil)
    
    init() {
        transform()
    }
}

private extension RandomPhotoViewModel {
    func transform() {
        inputViewDidLoadTrigger.bind(false) { [weak self] _ in
            self?.getRandomPhotos()
        }
        
        inputLikeItemAdd.bind { [weak self] item in
            guard let item else { return }
            UserDefaultsManager.likeList.insert(item.id)
            self?.repository?.createItem(data: item)
        }
        
        inputLikeItemRemove.bind { [weak self] item in
            guard let item, let deleteItem = self?.repository?.fetchItemFromProduct(id: item.id) else { return }
            UserDefaultsManager.likeList.remove(item.id)
            NotificationCenter.default.post(name: .likeItemWillBeRemoved, object: item)
            self?.repository?.deleteItem(data: deleteItem)
        }
    }
    
    func getRandomPhotos() {
        NetworkManager.shared.getPhotoData(api: .random, responseType: [PhotoItem].self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.outputList.value = success
            case .failure(let failure):
                self?.outputNetworkError.value = failure
            }
        }
    }
}
