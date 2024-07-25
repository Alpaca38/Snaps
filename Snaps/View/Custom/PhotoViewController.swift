//
//  PhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit

class PhotoViewController: BaseViewController {
    typealias DataSource<S: SectionType, T: SectionItem> = UICollectionViewDiffableDataSource<S, T>
    typealias CellRegistration<T: SectionItem> = UICollectionView.CellRegistration<PhotoCell, T>
    typealias Snapshot<S: SectionType, T: SectionItem> = NSDiffableDataSourceSnapshot<S, T>
}
