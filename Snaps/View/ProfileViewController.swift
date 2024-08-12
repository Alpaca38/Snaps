//
//  ProfileViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {
    var updateImage: (() -> Void)?
    private let tapGesture = UITapGestureRecognizer()
    
    private lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.bigProfile / 2, alpha: Image.Alpha.active)
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        self.view.addSubview(view)
        return view
    }()
    private lazy var cameraImageView = {
        let view = UIImageView()
        view.backgroundColor = Color.main
        view.tintColor = Color.white
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Image.Size.camera / 2
        view.image = Image.camera
        self.view.addSubview(view)
        return view
    }()
    private lazy var nicknameTextField = {
        let view = NicknameTextField()
        self.view.addSubview(view)
        return view
    }()
    private lazy var textFieldStateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = Color.main
        self.view.addSubview(label)
        return label
    }()
    private lazy var completeButton = {
        let button = CustomButton(title: "완료")
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var mbtiView = {
        let view = MBTIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var withdrawalButton = {
        var config = UIButton.Configuration.borderless()
        config.titleAlignment = .center
        config.baseBackgroundColor = .clear
        let view = UIButton(configuration: config)
        view.setAttributedTitle(NSAttributedString(string: "회원탈퇴", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .light),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]), for: .normal)
        self.view.addSubview(view)
        return view
    }()
    
    private let saveButton = UIBarButtonItem(title: "저장")
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        configureView()
        bindData()
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Image.Size.bigProfile)
        }
        
        cameraImageView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(profileImageView)
            $0.size.equalTo(Image.Size.camera)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(cameraImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        textFieldStateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        
        mbtiView.snp.makeConstraints {
            $0.top.equalTo(textFieldStateLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(180)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension ProfileViewController {
    func configureView() {
        if UserDefaultsManager.isLogin {
            completeButton.isHidden = true
            withdrawalButton.isHidden = false
            
            profileImageView.image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage)
            
            nicknameTextField.text = UserDefaultsManager.user.nickname
            
            mbtiView.mbtiItems = UserDefaultsManager.user.mbti
            mbtiView.sectionRelay.accept([MBTIView.MBTISection(model: 0, items: mbtiView.mbtiItems)])
        } else {
            completeButton.isHidden = false
            withdrawalButton.isHidden = true
        }
    }
    
    func setNavi() {
        if UserDefaultsManager.isLogin {
            navigationItem.title = NaviTitle.editProfile
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.title = NaviTitle.profileSetting
            setRandomImage()
        }
    }
    
    func setRandomImage() {
        let random = Int.random(in: 0..<Image.Profile.allCases.count)
        UserDefaultsManager.user.image = random
        profileImageView.image = UIImage(named: Image.Profile.allCases[random].profileImage)
    }
    
    func bindData() {
        let mbti = BehaviorRelay(value: mbtiView.mbtiItems)
        let profileImage = PublishRelay<Int>()
        let delete = PublishRelay<Void>()
        
        let input = ProfileViewModel.Input(
            text: nicknameTextField.rx.text.orEmpty,
            mbti: mbti,
            profileImage: profileImage,
            completeTap: completeButton.rx.tap,
            saveTap: saveButton.rx.tap,
            withdrawalTap: withdrawalButton.rx.tap,
            delete: delete
        )
        
        let output = viewModel.transform(input: input)
        
        disposeBag.insert {
            output.validText
                .bind(to: textFieldStateLabel.rx.text)
            
            Observable.zip(mbtiView.collectionView.rx.itemSelected, mbtiView.collectionView.rx.modelSelected(MBTIItem.self))
                .bind(with: self) { owner, value in
                    owner.mbtiView.mbtiItems[value.0.item].selected = value.1.selected ? false : true
                    owner.updatePair(data: value.1)
                    
                    mbti.accept(owner.mbtiView.mbtiItems)
                    owner.mbtiView.sectionRelay.accept([MBTIView.MBTISection(model: 0, items: owner.mbtiView.mbtiItems)])
                }
            
            output.totalValid
                .bind(with: self) { owner, value in
                    owner.completeButton.backgroundColor = value ? Color.main : Color.gray
                    owner.completeButton.isEnabled = value
                    
                    let saveColor = value ? Color.black : Color.lightGray
                    owner.saveButton.setTitleTextAttributes([.foregroundColor: saveColor], for: .normal)
                    owner.saveButton.isEnabled = value
                }
            
            tapGesture.rx.event
                .bind(with: self, onNext: { owner, _ in
                    let vc = ProfileImageViewController()
                    vc.sendImage = { image in
                        owner.profileImageView.image = UIImage(named: image)
                        profileImage.accept(Image.Profile.allCases.firstIndex(where: { $0.profileImage == image })!)
                    }
                    owner.navigationController?.pushViewController(vc, animated: true)
                })
            
            output.completeTap
                .bind { _ in
                    SceneManager.shared.setScene(viewController: TabBarController())
                }
            
            output.saveTap
                .bind(with: self) { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                    owner.updateImage?()
                }
            
            output.withdrawalTap
                .bind(with: self) { owner, _ in
                    owner.showAlert(title: "회원을 탈퇴하시겠습니까?", message: "회원을 탈퇴하면 저장된 모든 정보가 사라집니다. 정말로 탈퇴하시겠습니까?", buttonTitle: "네") {
                        delete.accept(())
                        
                        SceneManager.shared.setNaviScene(viewController: OnBoardingViewController())
                    }
                }
        }
    }
}

extension ProfileViewController {
    private func updatePair(data: MBTIItem) {
        let pairs: [String: String] = [
            "E": "I", "I": "E",
            "S": "N", "N": "S",
            "T": "F", "F": "T",
            "J": "P", "P": "J"
        ]
        guard let pairElement = pairs[data.element] else { return }
        // 짝이 되는 값의 위치의 selected 값 업데이트
        for (index, item) in mbtiView.mbtiItems.enumerated() {
            if item.element == pairElement {
                mbtiView.mbtiItems[index].selected = false
            }
        }
    }
}
