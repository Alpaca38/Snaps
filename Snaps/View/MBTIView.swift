//
//  MBTIView.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit

final class MBTIView: BaseView {
    var dataSource: DataSource!
    var mbtiItems = [MBTIItem(element: "E"),
                             MBTIItem(element: "S"),
                             MBTIItem(element: "T"),
                             MBTIItem(element: "J"),
                             MBTIItem(element: "I"),
                             MBTIItem(element: "N"),
                             MBTIItem(element: "F"),
                             MBTIItem(element: "P")]
    
    private lazy var titleLabel = {
        let view = UILabel()
        view.text = "MBTI"
        view.font = .boldSystemFont(ofSize: 17)
        addSubview(view)
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDataSource()
        updateSnapshot()
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(60)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: CollectionView Layout
private extension MBTIView {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: Diffable DataSource
extension MBTIView {
    func configureDataSource() {
        let cellRegistration = MBTIRegistration { cell, indexPath, itemIdentifier in
            cell.configure(data: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(mbtiItems)
        
        dataSource.apply(snapshot)
    }
}

extension MBTIView {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MBTIItem>
    typealias MBTIRegistration = UICollectionView.CellRegistration<MBTICell, MBTIItem>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, MBTIItem>
}

struct MBTIItem: Codable, Hashable {
    let element: String
    var selected: Bool = false
}
