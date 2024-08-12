//
//  MBTIView.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

final class MBTIView: BaseView {
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
    
    private var dataSource: DataSource!
    
    lazy var sectionRelay = BehaviorRelay(value: [MBTISection(model: 0, items: mbtiItems)])
    
    var mbtiItems = [MBTIItem(element: "E"),
                             MBTIItem(element: "S"),
                             MBTIItem(element: "T"),
                             MBTIItem(element: "J"),
                             MBTIItem(element: "I"),
                             MBTIItem(element: "N"),
                             MBTIItem(element: "F"),
                             MBTIItem(element: "P")]
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDataSource()
        bind()
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
        
        dataSource = DataSource(configureCell: { MBTISection, collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func bind() {
        sectionRelay
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MBTIView {
    typealias MBTISection = AnimatableSectionModel<Int, MBTIItem>
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<MBTISection>
    typealias MBTIRegistration = UICollectionView.CellRegistration<MBTICell, MBTIItem>
}

struct MBTIItem: Codable, Hashable, IdentifiableType {
    var identity = UUID().uuidString
    let element: String
    var selected: Bool = false
}


