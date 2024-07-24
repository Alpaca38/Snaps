//
//  LikesViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import Foundation

final class LikesViewModel {
    let repository = LikeRepository()
    
    private(set) var outputList = Observable<[LikeItems]>([])
    
    var inputViewWillAppearEvent = Observable<Void?>(nil)
    var inputLikeButtonTapped = Observable<LikeItems?>(nil)
    var inputSortButton = Observable<Bool>(false)
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLikeItemWillBeRemoved(_:)), name: .likeItemWillBeRemoved, object: nil)
        repository.printRealmURL()
        transform()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension LikesViewModel {
    func transform() {
        inputViewWillAppearEvent.bind(false) { [weak self] _ in
            self?.fetchList()
        }
        
        inputLikeButtonTapped.bind { [weak self] item in
            guard let item, let deleteItem = self?.repository.fetchItemFromProduct(id: item.id) else { return }
            UserDefaultsManager.likeList.remove(item.id)
            self?.outputList.value.removeAll(where: { $0 == item })
            self?.repository.deleteItem(data: deleteItem)
        }
        
        inputSortButton.bind(false) { [weak self] isLatest in
            isLatest ? self?.fetchLatestList() : self?.fetchList()
        }
    }
    
    func fetchList() {
        outputList.value = repository.fetchSort(keyPath: "regDate", ascending: true)
    }
    
    func fetchLatestList() {
        outputList.value = repository.fetchSort(keyPath: "regDate", ascending: false)
    }
    
    @objc func handleLikeItemWillBeRemoved(_ notification: Notification) {
        guard let item = notification.object as? LikeItems else { return }
        outputList.value.removeAll { $0.id == item.id }
    }
}

extension Notification.Name {
    static let likeItemWillBeRemoved = Notification.Name("likeItemWillBeRemoved")
}
