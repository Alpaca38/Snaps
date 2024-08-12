//
//  SearchPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation

final class SearchPhotoViewModel {
    private let repository = try? RealmRepository<LikeItems>()
    
    var outputList = CustomObservable<[PhotoItem]>([])
    var outputColor = CustomObservable<[PhotoColorItem]>([])
    var outputNetworkError = CustomObservable<APIError?>(nil)
    var outputSort = CustomObservable<SortOrder>(.relevant)
    var outputListIsNotEmpty = CustomObservable<Void?>(nil)
    var outputSearchTextIsEmpty = CustomObservable<Void?>(nil)
    var outputSearchTextIsNotEmpty = CustomObservable<Void?>(nil)
    
    var inputViewDidLoadTrigger = CustomObservable<Void?>(nil)
    var inputText = CustomObservable<String?>(nil)
    var inputSortButton = CustomObservable<Bool>(false)
    var inputPage = CustomObservable<Int>(1)
    var inputLikeItemRemove = CustomObservable<LikeItems?>(nil)
    var inputLikeItemAdd = CustomObservable<(Data?, Data?, LikeItems?)>((nil, nil, nil))
    var inputColor = CustomObservable<PhotoColor?>(nil)
    
    init() {
        transform()
    }
}

private extension SearchPhotoViewModel {
    func transform() {
        inputViewDidLoadTrigger.bind(false) { [weak self] _ in
            self?.outputColor.value = PhotoColor.allCases.map({ PhotoColorItem(photoColor: $0)})
        }
        
        inputText.bind(false) { [weak self] searchText in
            guard let self, let searchText else { return }
            if searchText.isEmpty {
                outputSearchTextIsEmpty.value = ()
                outputList.value = []
            } else {
                outputSearchTextIsNotEmpty.value = ()
                getSearchPhotos(searchText: searchText, orderBy: outputSort.value.rawValue)
            }
        }
        
        inputSortButton.bind(false) { [weak self] selected in
            self?.outputSort.value = selected ? .latest : .relevant
        }
        
        inputPage.bind(false) { [weak self] page in
            guard let self, let searchText = inputText.value else { return }
            if let color = inputColor.value {
                getSearchColorPhotos(searchText: searchText, orderBy: outputSort.value.rawValue, color: color.rawValue)
            } else {
                getSearchPhotos(searchText: searchText, orderBy: outputSort.value.rawValue)
            }
        }
        
        inputLikeItemAdd.bind { [weak self] (photoData, profileData, item) in
            guard let item, let photoData, let profileData else { return }
            FileUtility.shared.saveImageToDocument(data: photoData, filename: item.id)
            FileUtility.shared.saveImageToDocument(data: profileData, filename: item.photoGrapherID)
            
            UserDefaultsManager.likeList.insert(item.id)
            self?.repository?.createItem(data: item)
        }
        
        inputLikeItemRemove.bind { [weak self] item in
            guard let item, let deleteItem = self?.repository?.fetchItemFromProduct(id: item.id) else { return }
            UserDefaultsManager.likeList.remove(item.id)
            
            NotificationCenter.default.post(name: .likeItemWillBeRemoved, object: item)
            self?.repository?.deleteItem(data: deleteItem)
        }
        
        inputColor.bind(false) { [weak self] color in
            guard let self else { return }
            if let color {
                getSearchColorPhotos(searchText: inputText.value ?? "", orderBy: outputSort.value.rawValue, color: color.rawValue)
            } else {
                getSearchPhotos(searchText: inputText.value ?? "", orderBy: outputSort.value.rawValue)
            }
        }
    }
    
    func getSearchPhotos(searchText: String, orderBy: SortOrder.RawValue) {
        NetworkManager.shared.getSearchPhotos(searchText: searchText, page: inputPage.value, orderBy: orderBy) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                if inputPage.value == 1 {
                    outputList.value = success.results
                    if !outputList.value.isEmpty {
                        outputListIsNotEmpty.value = ()
                    }
                } else {
                    outputList.value.append(contentsOf: success.results)
                }
            case .failure(let failure):
                outputNetworkError.value = failure
            }
        }
    }
    
    func getSearchColorPhotos(searchText: String, orderBy: SortOrder.RawValue, color: PhotoColor.RawValue) {
        NetworkManager.shared.getSearchColorPhotos(searchText: searchText, page: inputPage.value, orderBy: orderBy, color: color) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                if inputPage.value == 1 {
                    outputList.value = success.results
                    if !outputList.value.isEmpty {
                        outputListIsNotEmpty.value = ()
                    }
                } else {
                    outputList.value.append(contentsOf: success.results)
                }
            case .failure(let failure):
                outputNetworkError.value = failure
            }
        }
    }
}
