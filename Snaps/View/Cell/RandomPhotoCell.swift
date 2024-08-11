//
//  RandomPhotoCell.swift
//  Snaps
//
//  Created by 조규연 on 7/25/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RandomPhotoCell: BaseCollectionViewCell {
    var likeButtonTapped: ((Data, Data) -> Void)?
    
    private lazy var photoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var pageLabel = {
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = Color.darkGray
        config.cornerStyle = .capsule
        let view = UIButton(configuration: config)
        view.isEnabled = false
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var profileImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFit
        contentView.addSubview(view)
        return view
    }()
    
    private let profileLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = Color.white
        return view
    }()
    
    private let photoCreatedLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 13)
        view.textColor = Color.white
        return view
    }()
    
    private lazy var labelStackView = {
        let view = UIStackView(arrangedSubviews: [profileLabel, photoCreatedLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var likeButton = {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = Image.likeInactive
        config.title = nil
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        profileImage.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImage)
            $0.height.equalTo(profileImage).multipliedBy(0.95)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
    }
    
    func configure(data: PhotoItem, indexPath: IndexPath) {
        let photoURL = URL(string: data.urls.regular)
        let photoProcessor = DownsamplingImageProcessor(size: photoImageView.bounds.size)
        photoImageView.kf.setImage(
            with: photoURL,
            options: [
                .processor(photoProcessor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        
        pageLabel.setAttributedTitle(NSAttributedString(string: "\(indexPath.item + 1) / 10", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: Color.white
        ]), for: .normal)
        
        let profileURL = URL(string: data.user.profileImage.medium)
        let profileProcessor = DownsamplingImageProcessor(size: profileImage.bounds.size)
        profileImage.kf.setImage(
            with: profileURL,
            options: [
                .processor(profileProcessor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        
        profileLabel.text = data.user.name
        photoCreatedLabel.text = data.koreanDate
        
        if UserDefaultsManager.likeList.contains(data.id) {
            likeButton.setImage(Image.like, for: .normal)
        } else {
            likeButton.setImage(Image.likeInactive, for: .normal)
        }
    }
}

private extension RandomPhotoCell {
    @objc func likeButtonTapped(_ sender: UIButton) {
        if let profileData = profileImage.image?.jpegData(compressionQuality: 0.5), let photoData = photoImageView.image?.jpegData(compressionQuality: 0.5) {
            likeButtonTapped?(profileData, photoData)
        }
    }
}
