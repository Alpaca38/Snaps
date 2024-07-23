//
//  PhotoCell.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoCell: BaseCollectionViewCell {
    private lazy var mainImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = Color.lightGray
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var likeCountView = {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleContainer.foregroundColor = Color.white
        
        var config = UIButton.Configuration.tinted()
        config.cornerStyle = .capsule
        config.image = Image.star?.withRenderingMode(.alwaysOriginal).withTintColor(.yellow)
        config.attributedTitle = AttributedString("1,643", attributes: titleContainer)
        
        let view = UIButton(configuration: config)
        view.isEnabled = false
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
        view.setImage(Image.likeCircle, for: .selected)
        view.setImage(Image.likeCircleInactive, for: .normal)
        contentView.addSubview(view)
        return view
    }()
    
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
        
        likeCountView.setTitle(data.likes.formatted(), for: .normal)
        likeCountView.setAttributedTitle(NSAttributedString(string: data.likes.formatted(), attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: Color.white
        ]), for: .normal)
                
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
}

private extension PhotoCell {
    @objc func likeButtonTapped(_ sender: UIButton) {
        // inputSelectedButton
        sender.isSelected.toggle()
    }
}

extension PhotoCell {
    enum Category {
        case trend
        case search
        case like
    }
}
