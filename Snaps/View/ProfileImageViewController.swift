//
//  ProfileImageViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

final class ProfileImageViewController: BaseViewController {
    let viewModel = ProfileImageViewModel()
    var sendImage: ((String) -> Void)?
    
    private lazy var imageView = {
        let view = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.bigProfile / 2, alpha: Image.Alpha.active)
        view.image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
        view.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.identifier)
        view.delegate = self
        view.dataSource = self
        self.view.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        bindData()
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Image.Size.bigProfile)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNavi() {
        if UserDefaultsManager.isLogin {
            title = NaviTitle.editProfile
        } else {
            title = NaviTitle.profileSetting
        }
    }
}

// MARK: CollectionView Layout
private extension ProfileImageViewController {
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 10
        let width = view.frame.width - sectionSpacing * 2 - cellSpacing * 3
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}

private extension ProfileImageViewController {
    func bindData() {
        viewModel.outputImage.bind { [weak self] image in
            guard let image else { return }
            self?.sendImage?(image)
            self?.imageView.image = UIImage(named: image)
            self?.collectionView.reloadData()
        }
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Image.Profile.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
        let isSelected = viewModel.inputSelectedIndex.value == indexPath.item
        cell.configure(index: indexPath.item, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectedIndex.value = indexPath.item
    }
}
