//
//  PhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit

protocol SectionType: Hashable {}
protocol SectionItem: Hashable {}

enum Section: CaseIterable, SectionType {
    case main
}

class PhotoViewController: BaseViewController {


    enum TopicSection: CaseIterable, SectionType {
        case goldenHour
        case businessAndWork
        case architectureAndInterior
        
        var headerTitle: String {
            switch self {
            case .goldenHour:
                return "골든 아워"
            case .businessAndWork:
                return "비지니스 및 업무"
            case .architectureAndInterior:
                return "건축 및 인테리어"
            }
        }
    }
    
    typealias DataSource<S: SectionType, T: SectionItem> = UICollectionViewDiffableDataSource<S, T>
    typealias CellRegistration<T: SectionItem> = UICollectionView.CellRegistration<PhotoCell, T>
    typealias Snapshot<S: SectionType, T: SectionItem> = NSDiffableDataSourceSnapshot<S, T>
}
