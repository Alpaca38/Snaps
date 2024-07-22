//
//  NicknameTextField.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

final class NicknameTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        self.placeholder = "닉네임을 입력해주세요 :)"
        self.font = .boldSystemFont(ofSize: 15)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.underlined()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = Color.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
