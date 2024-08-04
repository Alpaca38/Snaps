//
//  NetworkErrorView.swift
//  Snaps
//
//  Created by 조규연 on 7/30/24.
//

import UIKit
import SnapKit

final class NetworkErrorView: BaseView {
    private lazy var errorLabel = {
        let view = UILabel()
        view.backgroundColor = .systemRed
        view.textAlignment = .center
        view.text = "네트워크 연결이 해제되었습니다."
        addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        errorLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
