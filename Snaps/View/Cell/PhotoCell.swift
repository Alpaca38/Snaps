//
//  PhotoCell.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class PhotoCell: BaseCollectionViewCell {
    var likeButtonTapped: ((UIImage) -> Void)?
    
    private lazy var mainImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
//        view.backgroundColor = Color.lightGray
        view.isSkeletonable = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var likeCountView = {
        var config = UIButton.Configuration.tinted()
        config.cornerStyle = .capsule
        config.image = Image.star?.withRenderingMode(.alwaysOriginal).withTintColor(.yellow)
        config.imagePadding = 8
        
        let view = UIButton(configuration: config)
        view.isEnabled = false
        view.isSkeletonable = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var likeButton = {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = Image.likeCircleInactive
        config.title = nil
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        view.isSkeletonable = true
        contentView.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        likeCountView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(10)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: PhotoItem, category: Category) {
        let url = URL(string: data.urls.small)
        mainImageView.kf.setImage(with: url)
        likeCountView.setAttributedTitle(NSAttributedString(string: data.likes.formatted(), attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: Color.white
        ]), for: .normal)
                
        if UserDefaultsManager.likeList.contains(data.id) {
            likeButton.setImage(Image.likeCircle, for: .normal)
        } else {
            likeButton.setImage(Image.likeCircleInactive, for: .normal)
        }
        
        switch category {
        case .trend:
            mainImageView.layer.cornerRadius = 12
            likeButton.isHidden = true
        case .search:
            likeButton.isHidden = false
            likeCountView.isHidden = false
        case .like:
            likeCountView.isHidden = true
        }
    }
    
    func configure(data: LikeItems) {
        mainImageView.image = loadImageToDocument(filename: data.id)
        likeCountView.isHidden = true
        likeButton.setImage(Image.likeCircle, for: .normal)
    }
}

private extension PhotoCell {
    @objc func likeButtonTapped(_ sender: UIButton) {
        if let image = mainImageView.image {
            likeButtonTapped?(image)
        }
    }
}

extension PhotoCell {
    enum Category {
        case trend
        case search
        case like
    }
}
