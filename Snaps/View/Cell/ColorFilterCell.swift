//
//  ColorFilterCell.swift
//  Snaps
//
//  Created by 조규연 on 7/26/24.
//

import UIKit
import SnapKit

final class ColorFilterCell: BaseCollectionViewCell {
    private lazy var customBackgroundView = {
        let view = UIView()
        view.backgroundColor = Color.lightGray
        view.layer.cornerRadius = 20
        view.addSubview(stackView)
        contentView.addSubview(view)
        return view
    }()
    
    private let colorView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let colorLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [colorView, colorLabel])
        view.axis = .horizontal
        view.spacing = 6
        return view
    }()
    
    override func configureLayout() {
        customBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(5)
        }
        
        colorView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
    }
    
    func configure(data: PhotoColorItem) {
        colorView.backgroundColor = data.photoColor.imageColor
        colorLabel.text = data.photoColor.colorTitle
        if data.isSelected {
            customBackgroundView.backgroundColor = .systemBlue
            colorLabel.textColor = Color.white
        } else {
            customBackgroundView.backgroundColor = Color.lightGray
            colorLabel.textColor = Color.black
        }
    }
}
