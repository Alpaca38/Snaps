//
//  SearchPhotoViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import Foundation

final class SearchPhotoViewModel {
    private(set) var outputList = Observable<[PhotoItem]>([])
    private(set) var outputNetworkError = Observable<APIError?>(nil)
    private(set) var outputSort = Observable<SortOrder>(.relevant)
    private(set) var outputListIsNotEmpty = Observable<Void?>(nil)
    
    var inputText = Observable<String?>(nil)
    var inputSortButton = Observable<Bool>(false)
    var inputPage = Observable<Int>(1)
    
    init() {
        inputText.bind(false) { [weak self] searchText in
            guard let self, let searchText else { return }
            getSearchPhotos(searchText: searchText, orderBy: outputSort.value.rawValue)
        }
        
        inputSortButton.bind(false) { [weak self] selected in
            self?.outputSort.value = selected ? .latest : .relevant
        }
        
        inputPage.bind(false) { [weak self] page in
            guard let self, let searchText = inputText.value else { return }
            getSearchPhotos(searchText: searchText, orderBy: outputSort.value.rawValue)
        }
    }
}

private extension SearchPhotoViewModel {
    func getSearchPhotos(searchText: String, orderBy: SortOrder.RawValue) {
        NetworkManager.shared.getPhotoData(api: .search(query: searchText, page: inputPage.value, perPage: 20, orderBy: orderBy), responseType: Photos.self) { [weak self] result in
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
