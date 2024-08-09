//
//  RandomPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import UIKit
import SnapKit

final class RandomPhotoViewController: BaseViewController {
    private var dataSource: DataSource!
    private let viewModel = RandomPhotoViewModel()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: UI
private extension RandomPhotoViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                             heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        config.contentInsetsReference = .none
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
}

// MARK: DataSource
private extension RandomPhotoViewController {
    func configureDataSource() {
        let cellRegistration = CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            cell.likeButtonTapped = { profileImage, photoImage in
                if UserDefaultsManager.likeList.contains(itemIdentifier.id) {
                    self?.viewModel.inputLikeItemRemove.value = LikeItems(from: itemIdentifier)
                } else {
                    self?.viewModel.inputLikeItemAdd.value = LikeItems(from: itemIdentifier)
                    FileUtility.shared.saveImageToDocument(image: profileImage, filename: itemIdentifier.user.id)
                    FileUtility.shared.saveImageToDocument(image: photoImage, filename: itemIdentifier.id)
                }
                self?.collectionView.reloadData()
            }
            cell.configure(data: itemIdentifier, indexPath: indexPath)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputList.value, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}

// MARK: Data Bind
private extension RandomPhotoViewController {
    func bindData() {
        viewModel.outputList.bind(false) { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputNetworkError.bind { [weak self] error in
            self?.view.makeToast(error?.rawValue, position: .center)
        }
    }
}

extension RandomPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPhotoViewController()
        let data = dataSource.itemIdentifier(for: indexPath)
        vc.viewModel.inputSelectedPhoto.value = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension RandomPhotoViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhotoItem>
    typealias CellRegistration = UICollectionView.CellRegistration<RandomPhotoCell, PhotoItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PhotoItem>
}
