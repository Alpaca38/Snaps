//
//  TopicPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit

final class TopicPhotoViewController: PhotoViewController {
    private let viewModel = TopicPhotoViewModel()
    private var dataSource: DataSource<TopicSection>!
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        configureDataSource()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: UI
private extension TopicPhotoViewController {
    func setNavi() {
        navigationItem.title = "OUR TOPIC"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let sectionType = TopicSection.allCases[sectionIndex]
            
            switch sectionType {
            case .goldenHour:
                let section = self?.createSection()
                section?.boundarySupplementaryItems = [header]
                return section
            case .businessAndWork:
                let section = self?.createSection()
                section?.boundarySupplementaryItems = [header]
                return section
            case .architectureAndInterior:
                let section = self?.createSection()
                section?.boundarySupplementaryItems = [header]
                return section
            }
        }
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}

// MARK: Bind Data
private extension TopicPhotoViewController {
    func bindData() {
        viewModel.outputGoldenHour.bind(false) { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputBusiness.bind(false) { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputArchitecture.bind(false) { [weak self] _ in
            self?.updateSnapshot()
        }
    }
}

// MARK: DataSource
private extension TopicPhotoViewController {
    func configureDataSource() {
        let cellRegistration = CellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(data: itemIdentifier, category: .trend)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self else { return }
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            var content = UIListContentConfiguration.groupedHeader()
            content.text = section.headerTitle
            content.textProperties.font = .boldSystemFont(ofSize: 17)
            content.textProperties.color = Color.black
            
            supplementaryView.contentConfiguration = content
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot<TopicSection>()
        snapshot.appendSections(TopicSection.allCases)
        
        snapshot.appendItems(viewModel.outputGoldenHour.value, toSection: .goldenHour)
        snapshot.appendItems(viewModel.outputBusiness.value, toSection: .businessAndWork)
        snapshot.appendItems(viewModel.outputArchitecture.value, toSection: .architectureAndInterior)
        
        dataSource.apply(snapshot)
    }
}
