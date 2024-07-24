//
//  SearchPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit
import Toast

final class SearchPhotoViewController: PhotoViewController {
    private let viewModel = SearchPhotoViewModel()
    private var dataSource: DataSource<Section, PhotoItem>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var sortButton = {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = Color.black
        config.image = Image.sort
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.title = "최신순"
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        view.setTitle("최신순", for: .normal)
        view.setTitle("관련순", for: .selected)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.prefetchDataSource = self
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var emptyResultLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "검색 결과가 없습니다."
        view.isHidden = true
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setSearchController()
        configureDataSource()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
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
        
        emptyResultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
        sender.isSelected.toggle()
        viewModel.inputSortButton.value = sender.isSelected
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
        let cellRegistration = CellRegistration<PhotoItem> { cell, indexPath, itemIdentifier in
            cell.likeButtonTapped = { [weak self] in
                if UserDefaultsManager.likeList.contains(itemIdentifier.id) {
                    
                    self?.viewModel.inputLikeItemRemove.value = LikeItems(from: itemIdentifier)
                } else {
                    self?.viewModel.inputLikeItemAdd.value = LikeItems(from: itemIdentifier)
                }
                self?.collectionView.reloadData()
            }
            cell.configure(data: itemIdentifier, category: .search)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot<Section, PhotoItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputList.value, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}

// MARK: Data Bind
private extension SearchPhotoViewController {
    func bindData() {
        viewModel.outputList.bind(false) { [weak self] items in
            items.isEmpty ? (self?.emptyResultLabel.isHidden = false) : (self?.emptyResultLabel.isHidden = true)
            self?.updateSnapshot()
        }
        
        viewModel.outputListIsNotEmpty.bind(false) { [weak self] _ in
            guard let self else { return }
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.outputNetworkError.bind { [weak self] error in
            self?.view.makeToast(error?.rawValue, position: .center)
        }
        
        viewModel.outputSort.bind { [weak self] _ in
            self?.viewModel.inputPage.value = 1
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        viewModel.inputText.value = text
    }
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let list = viewModel.outputList.value
        indexPaths.forEach {
            if list.count - 4 == $0.item {
                viewModel.inputPage.value += 1
            }
        }
    }
}
