//
//  SearchPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit
import Toast
import SkeletonView

final class SearchPhotoViewController: PhotoViewController {
    private let viewModel = SearchPhotoViewModel()
    private var colorDataSource: DataSource<Section, PhotoColorItem>!
    private var photoDataSource: DataSource<Section, PhotoItem>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var sortButton = {
        var config = UIButton.Configuration.gray()
        config.background.backgroundColor = Color.lightGray
        config.baseForegroundColor = Color.black
        config.image = Image.sort
        config.imagePadding = 4
        config.cornerStyle = .capsule
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        view.setAttributedTitle(NSAttributedString(string: "최신순", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: Color.black
        ]), for: .normal)
        view.setAttributedTitle(NSAttributedString(string: "관련순", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: Color.black
        ]), for: .selected)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var colorCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createColorCollectionViewLayout())
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var photoCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createPhotoCollectionViewLayout())
        view.delegate = self
        view.prefetchDataSource = self
        view.dataSource = self
        view.isSkeletonable = true
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
    
    private lazy var searchIndicateLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "사진을 검색해보세요."
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setSearchController()
        configureColorDataSource()
        configurePhotoDataSource()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoCollectionView.reloadData()
    }
    
    override func configureLayout() {
        colorCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(110)
            $0.height.equalTo(40)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emptyResultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        searchIndicateLabel.snp.makeConstraints {
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
    
    func createColorCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitem: item, count: 3)
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 4
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createPhotoCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitem: item, count: 2)
        group.interItemSpacing = .fixed(4)
      
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: DataSource
private extension SearchPhotoViewController {
    func configurePhotoDataSource() {
        let cellRegistration = CellRegistration<PhotoItem> { cell, indexPath, itemIdentifier in
            cell.likeButtonTapped = { [weak self] image in
                if UserDefaultsManager.likeList.contains(itemIdentifier.id) {
                    self?.viewModel.inputLikeItemRemove.value = LikeItems(from: itemIdentifier)
                    self?.removeImageFromDocument(filename: itemIdentifier.id)
                    self?.removeImageFromDocument(filename: itemIdentifier.user.id)
                } else {
                    self?.viewModel.inputLikeItemAdd.value = LikeItems(from: itemIdentifier)
                    self?.saveImageToDocument(image: image, filename: itemIdentifier.id)
                    DispatchQueue.global().async {
                        do {
                            guard let profileImageURL = URL(string: itemIdentifier.user.profileImage.medium) else { return }
                            let profileData = try Data(contentsOf: profileImageURL)
                            guard let profileImage = UIImage(data: profileData) else { return }
                            self?.saveImageToDocument(image: profileImage, filename: itemIdentifier.user.id)
                        } catch {
                            print("Image Data Error")
                        }
                    }
                }
                self?.photoCollectionView.reloadData()
            }
            cell.configure(data: itemIdentifier, category: .search)
        }
        
        photoDataSource = UICollectionViewDiffableDataSource(collectionView: photoCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updatePhotoSnapshot() {
        var snapshot = Snapshot<Section, PhotoItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputList.value, toSection: .main)
        
        photoDataSource.apply(snapshot)
    }
    
    func configureColorDataSource() {
        let cellRegistration = ColorCellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(data: itemIdentifier)
        }
        
        colorDataSource = UICollectionViewDiffableDataSource(collectionView: colorCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateColorSnapshot() {
        var snapshot = Snapshot<Section, PhotoColorItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputColor.value, toSection: .main)
        
        colorDataSource.apply(snapshot)
    }
}

// MARK: Data Bind
private extension SearchPhotoViewController {
    func bindData() {
        viewModel.outputList.bind(false) { [weak self] items in
            guard let text = self?.searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            !text.isEmpty && items.isEmpty ? (self?.emptyResultLabel.isHidden = false) : (self?.emptyResultLabel.isHidden = true)
            self?.photoCollectionView.hideSkeleton()
            self?.updatePhotoSnapshot()
        }
        
        viewModel.outputListIsNotEmpty.bind(false) { [weak self] _ in
            guard let self else { return }
            photoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        viewModel.outputNetworkError.bind { [weak self] error in
            self?.view.makeToast(error?.rawValue, position: .center)
        }
        
        viewModel.outputSort.bind { [weak self] _ in
            self?.viewModel.inputPage.value = 1
        }
        
        viewModel.outputSearchTextIsEmpty.bind(false) { [weak self] _ in
            self?.searchIndicateLabel.isHidden = false
        }
        
        viewModel.outputSearchTextIsNotEmpty.bind(false) { [weak self] _ in
            self?.searchIndicateLabel.isHidden = true
        }
        
        viewModel.outputColor.bind(false) { [weak self] _ in
            self?.updateColorSnapshot()
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        photoCollectionView.showSkeleton()
        viewModel.inputText.value = text
    }
}

extension SearchPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            guard let data = colorDataSource.itemIdentifier(for: indexPath) else { return }
            // 선택한 셀 상태 저장
            let isSelected = data.isSelected
            viewModel.outputColor.value = PhotoColor.allCases.map({ PhotoColorItem(photoColor: $0)})
            viewModel.outputColor.value[indexPath.item].isSelected = !isSelected
            
            if isSelected { // 셀 선택되어 있던 상태
                viewModel.inputColor.value = nil
            } else {
                viewModel.inputColor.value = data.photoColor
            }
        } else {
            let vc = DetailPhotoViewController()
            let data = photoDataSource.itemIdentifier(for: indexPath)
            vc.viewModel.inputSelectedPhoto.value = data
            navigationController?.pushViewController(vc, animated: true)
        }
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

extension SearchPhotoViewController {
    typealias ColorCellRegistration = UICollectionView.CellRegistration<ColorFilterCell, PhotoColorItem>
}

extension SearchPhotoViewController: SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PhotoCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let list = viewModel.outputList.value
        return list.count
    }
    
}
