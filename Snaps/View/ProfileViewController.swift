//
//  ProfileViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import SnapKit
import Toast

final class ProfileViewController: BaseViewController {
    var updateImage: (() -> Void)?
    
    private lazy var profileImageView = {
        let view = CircleImageView(borderWidth: Image.Border.active, borderColor: Color.main, cornerRadius: Image.Size.bigProfile / 2, alpha: Image.Alpha.active)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
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
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChage(_ :)), for: .editingChanged)
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
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    private lazy var mbtiView = {
        let view = MBTIView()
        view.collectionView.delegate = self
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
        view.addTarget(self, action: #selector(withdrawalButtonTaped), for: .touchUpInside)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
    
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
            viewModel.inputText.value = UserDefaultsManager.user.nickname
            
            mbtiView.mbtiItems = UserDefaultsManager.user.mbti
            viewModel.inputMBTI.value = UserDefaultsManager.user.mbti
            mbtiView.updateSnapshot()
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
        viewModel.outputValidText.bind { [weak self] in
            guard let self else { return }
            textFieldStateLabel.text = $0
        }
        
        viewModel.outputNickname.bind { nickname in
            guard let nickname else { return }
            UserDefaultsManager.user.nickname = nickname
        }
        
        viewModel.outputTotalValid.bind { [weak self] in
            guard let self else { return }
            completeButton.backgroundColor = $0 ? Color.main : Color.gray
            completeButton.isEnabled = $0
            $0 ? saveButton.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal) : saveButton.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
            saveButton.isEnabled = $0
        }
        
        viewModel.outputSaveImageIndex.bind { index in
            guard let index else { return }
            UserDefaultsManager.user.image = index
        }
        
        viewModel.outputMBTI.bind { mbti in
            guard let mbti else { return }
            UserDefaultsManager.user.mbti = mbti
        }
    }
}

private extension ProfileViewController {
    @objc func saveButtonTapped() {
        guard let nickname = nicknameTextField.text else { return }
        UserDefaultsManager.user.nickname = nickname
        UserDefaultsManager.user.mbti = mbtiView.mbtiItems
        viewModel.inputSaveImage.value = viewModel.outputImageIndex.value
        
        updateImage?()
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        guard let nickname = nicknameTextField.text else { return }
        viewModel.inputValidNickname.value = nickname
        viewModel.inputSaveImage.value = viewModel.outputImageIndex.value
        viewModel.inputValidMBTI.value = mbtiView.mbtiItems
        
        UserDefaultsManager.isLogin = true
        SceneManager.shared.setScene(viewController: TabBarController())
    }
    
    @objc func profileImageTapped() {
        let vc = ProfileImageViewController()
        vc.viewModel.inputSelectedIndex.value = viewModel.outputImageIndex.value ?? UserDefaultsManager.user.image
        vc.sendImage = { [weak self] image in
            self?.profileImageView.image = UIImage(named: image)
            self?.viewModel.inputSelectedImageIndex.value = Image.Profile.allCases.firstIndex(where: { $0.profileImage == image })
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func withdrawalButtonTaped() {
        showAlert(title: "회원을 탈퇴하시겠습니까?", message: "회원을 탈퇴하면 저장된 모든 정보가 사라집니다. 정말로 탈퇴하시겠습니까?", buttonTitle: "네") { [weak self] in
            self?.viewModel.inputWithdrawal.value = ()
            
            SceneManager.shared.setNaviScene(viewController: OnBoardingViewController())
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        viewModel.inputText.value = textField.text
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = mbtiView.dataSource.itemIdentifier(for: indexPath) else { return }
        
        mbtiView.mbtiItems[indexPath.item].selected = data.selected ? false : true
        updatePair(data: data)
        
        viewModel.inputMBTI.value = mbtiView.mbtiItems
        
        mbtiView.updateSnapshot()
    }
    
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
