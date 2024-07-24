//
//  LikesViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import UIKit

final class LikesViewController: PhotoViewController {
    private var dataSource: DataSource<Section>!
    
    private lazy var sortButton = {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = Color.black
        config.image = Image.sort
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.title = "과거순"
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        view.setTitle("과거순", for: .normal)
        view.setTitle("최신순", for: .selected)
        self.view.addSubview(view)
        return view
    }()
    
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
    }
    
    override func configureLayout() {
        sortButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: UI
private extension LikesViewController {
    func setNavi() {
        navigationItem.title = NaviTitle.mySnaps
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
//        viewModel.inputSortButton.value = sender.isSelected
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.interItemSpacing = .fixed(4)
      
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: DataSource
private extension LikesViewController {
    func configureDataSource() {
        let cellRegistration = CellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(data: itemIdentifier, category: .search)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot(items: [PhotoItem]) {
        var snapshot = Snapshot<Section>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}

// MARK: Data Bind
private extension LikesViewController {
    func bindData() {
        
    }
}
