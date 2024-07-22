//
//  MBTICell.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit

final class MBTICell: BaseCollectionViewCell {
    private let titleLabel = {
        let view = UILabel()
        view.textColor = Color.gray
        view.textAlignment = .center
        return view
    }()
    
    private lazy var circleView = {
        let view = UIView()
        view.layer.borderColor = Color.gray.cgColor
        view.layer.borderWidth = 1
        view.addSubview(titleLabel)
        contentView.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circleView.layer.cornerRadius = frame.size.width / 2
    }
    
    override func configureLayout() {
        circleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: MBTIItem) {
        titleLabel.text = data.element
        if data.selected {
            circleView.backgroundColor = Color.main
            titleLabel.textColor = Color.white
        } else {
            circleView.backgroundColor = .clear
            titleLabel.textColor = Color.gray
        }
    }
}
