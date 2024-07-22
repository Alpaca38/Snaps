//
//  ProfileImageCell.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit

final class ProfileImageCell: BaseCollectionViewCell {
    private lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.inActive, borderColor: Color.lightGray, cornerRadius: Image.Size.smallProfile / 2, alpha: Image.Alpha.inActive)
        self.contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(index: Int, isSelected: Bool) {
        profileImageView.image = UIImage(named: Image.Profile.allCases[index].profileImage)
        if isSelected {
            profileImageView.layer.borderWidth = Image.Border.active
            profileImageView.layer.borderColor = Color.main.cgColor
            profileImageView.alpha = Image.Alpha.active
        } else {
            profileImageView.layer.borderWidth = Image.Border.inActive
            profileImageView.layer.borderColor = Color.lightGray.cgColor
            profileImageView.alpha = Image.Alpha.inActive
        }
        
    }
}
