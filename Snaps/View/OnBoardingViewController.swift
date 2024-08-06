//
//  ViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnBoardingViewController: BaseViewController {
    private lazy var appTitle = {
        let view = UIImageView()
        view.image = Image.launchTitle
        view.contentMode = .scaleAspectFill
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var onBoardingImage = {
        let view = UIImageView()
        view.image = Image.lauchImage
        view.contentMode = .scaleAspectFill
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var startButton = {
        let button = CustomButton(title: "시작하기")
        self.view.addSubview(button)
        return button
    }()
    
    private let viewModel = OnBoardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureLayout() {
        appTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(100)
            $0.height.equalTo(80)
        }
        
        onBoardingImage.snp.makeConstraints {
            $0.top.equalTo(appTitle.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(400)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

private extension OnBoardingViewController {
    func bind() {
        let input = OnBoardingViewModel.Input(startTap: startButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.startTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(ProfileViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
