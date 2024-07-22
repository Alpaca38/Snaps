//
//  CircleImageView.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

final class CircleImageView: UIImageView {
    
    init(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, alpha: CGFloat) {
        super.init(frame: .zero)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.alpha = alpha
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
