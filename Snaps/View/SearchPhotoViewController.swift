//
//  SearchPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit

final class SearchPhotoViewController: BaseViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: DataSource!
    
    private lazy var sortButton = {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = Color.black
        config.image = Image.sort
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.title = "최신순"
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
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
        setSearchController()
        configureDataSource()
        updateSnapshot()
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
private extension SearchPhotoViewController {
    func setNavi() {
        navigationItem.title = NaviTitle.searchPhoto
    }
    
    func setSearchController() {        
        searchController.searchBar.placeholder = "사진을 검색할 수 있습니다."
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        // inputButtonTap
        sender.isSelected ? sender.setTitle("최신순", for: .normal) : sender.setTitle("관련순", for: .normal)
        sender.isSelected.toggle()
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
private extension SearchPhotoViewController {
    func configureDataSource() {
        let cellRegistration = SearchCellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(category: .search)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(["star", "star.fill", "asdfas", "adfasdf", "czvzvx"], toSection: .main)
        
        dataSource.apply(snapshot)
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//        inputSearchText
    }
}

private extension SearchPhotoViewController {
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias SearchCellRegistration = UICollectionView.CellRegistration<PhotoCell, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
}
