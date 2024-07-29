//
//  LikesViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import UIKit

final class LikesViewController: PhotoViewController {
    private var dataSource: DataSource<Section, LikeItems>!
    private let viewModel = LikesViewModel()
    
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
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var emptyResultLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "저장한 사진이 없습니다."
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        configureDataSource()
        bindData()
        viewModel.inputViewWillAppearEvent.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearEvent.value = ()
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
private extension LikesViewController {
    func setNavi() {
        navigationItem.title = NaviTitle.mySnaps
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.inputSortButton.value = sender.isSelected
    }
    
    func createLayout() -> UICollectionViewLayout {
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
private extension LikesViewController {
    func configureDataSource() {
        let cellRegistration = CellRegistration<LikeItems> { cell, indexPath, itemIdentifier in
            cell.likeButtonTapped = { [weak self] image in
                self?.removeImageFromDocument(filename: itemIdentifier.id)
                self?.removeImageFromDocument(filename: itemIdentifier.photoGrapherID)
                self?.viewModel.inputLikeButtonTapped.value = itemIdentifier
            }
            cell.configure(data: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot(items: [LikeItems]) {
        var snapshot = Snapshot<Section, LikeItems>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}

// MARK: Data Bind
private extension LikesViewController {
    func bindData() {
        viewModel.outputList.bind(false) { [weak self] items in
            items.isEmpty ? (self?.emptyResultLabel.isHidden = false) : (self?.emptyResultLabel.isHidden = true)
            self?.updateSnapshot(items: items)
        }
    }
}

extension LikesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPhotoViewController()
        guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
        vc.viewModel.inputLikedPhoto.value = PhotoItem.toPhotoItem(likeItem: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
