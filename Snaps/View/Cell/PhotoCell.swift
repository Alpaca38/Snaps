//
//  PhotoCell.swift
//  Snaps
//
//  Created by 조규연 on 7/23/24.
//

import UIKit
import SnapKit

final class PhotoCell: BaseCollectionViewCell {
    private lazy var mainImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
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
    
    func configure(category: Category) {
        
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
