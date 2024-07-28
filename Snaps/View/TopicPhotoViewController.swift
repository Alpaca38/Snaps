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
    private var dataSource: DataSource<TopicSection, PhotoItem>!
    
    private var randomTopicList: [Topic] = []
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        fetchRandomTopic()
        configureDataSource()
        bindData()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        let profileImageView = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: 20, alpha: Image.Alpha.active)
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        if let image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage) { profileImageView.image = image }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
        
        let profileButton = UIBarButtonItem(customView: profileImageView)
        navigationItem.rightBarButtonItem = profileButton
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = self?.createSection()
            section?.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func fetchRandomTopic() {
        let topicList = Topic.allCases.shuffled()
        randomTopicList = topicList
        viewModel.inputTopic.value = topicList.map({ $0.rawValue })
    }
    
    func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
}

// MARK: Action
private extension TopicPhotoViewController {
    @objc func profileButtonTapped() {
        let vc = ProfileViewController()
        vc.updateImage = { [weak self] in
            self?.setNavi()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefreshControl() {
        viewModel.inputRefresh.value = ()
    }
}

// MARK: Bind Data
private extension TopicPhotoViewController {
    func bindData() {
        viewModel.outputUpdateSnapshot.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.isRefreshing.bind { [weak self] _ in
            self?.fetchRandomTopic()
        }
        
        viewModel.refreshCompleted.bind { [weak self] _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: DataSource
private extension TopicPhotoViewController {
    func configureDataSource() {
        let cellRegistration = CellRegistration<PhotoItem> { cell, indexPath, itemIdentifier in
            cell.configure(data: itemIdentifier, category: .trend)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self else { return }
            let topic = randomTopicList[indexPath.section]
            var content = UIListContentConfiguration.groupedHeader()
            content.text = topic.headerTitle
            content.textProperties.font = .boldSystemFont(ofSize: 17)
            content.textProperties.color = Color.black
            
            supplementaryView.contentConfiguration = content
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot<TopicSection, PhotoItem>()
        snapshot.appendSections(TopicSection.allCases)
        snapshot.reloadSections(TopicSection.allCases)
        
        snapshot.appendItems(viewModel.outputFirstSectionData.value, toSection: .first)
        snapshot.appendItems(viewModel.outputSecondSectionData.value, toSection: .second)
        snapshot.appendItems(viewModel.outputThirdSectonData.value, toSection: .third)
        
        dataSource.apply(snapshot)
    }
}

extension TopicPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPhotoViewController()
        let data = dataSource.itemIdentifier(for: indexPath)
        vc.viewModel.inputSelectedPhoto.value = data
        navigationController?.pushViewController(vc, animated: true)
    }
}
