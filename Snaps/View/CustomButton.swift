//
//  CustomLabel.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit

final class CustomButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        self.setTitleColor(Color.white, for: .normal)
        self.layer.cornerRadius = 20
        self.backgroundColor = Color.main
        
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
