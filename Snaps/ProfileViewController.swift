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
    
    let viewModel = ProfileViewModel()
    
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
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStateLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
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
        } else {
            completeButton.isHidden = false
        }
    }
    
    func setNavi() {
        if UserDefaultsManager.user.nickname == "" {
            title = "PROFILE SETTING"
            setRandomImage()
        } else {
            navigationItem.title = "EDIT PROFILE"
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
            profileImageView.image = UIImage(named: Image.Profile.allCases[UserDefaultsManager.user.image].profileImage)
        }
    }
    
    func setRandomImage() {
        let random = Int.random(in: 0..<Image.Profile.allCases.count)
        UserDefaultsManager.user.image = random
        profileImageView.image = UIImage(named: Image.Profile.allCases[random].profileImage)
    }
    
    @objc func saveButtonTapped() {
        if textFieldStateLabel.text == TextFieldState.valid || nicknameTextField.text == UserDefaultsManager.user.nickname {
            guard let nickname = nicknameTextField.text else { return }
            UserDefaultsManager.user.nickname = nickname
            
            navigationController?.popViewController(animated: true)
        } else {
            view.makeToast("사용할 수 없는 닉네임입니다.", duration: 2.0, position: .center)
        }
    }
    
    func bindData() {
        viewModel.outputValidText.bind { [weak self] in
            guard let self else { return }
            textFieldStateLabel.text = $0
        }
        
        viewModel.outputNickname.bind { nickname in
            guard let nickname else { return }
            UserDefaultsManager.user.nickname = nickname
            UserDefaultsManager.isLogin = true
            SceneManager.shared.setScene(viewController: TabBarController())
        }
        
        viewModel.outputValid.bind { [weak self] in
            guard let self else { return }
            completeButton.backgroundColor = $0 ? Color.main : .gray
            completeButton.isEnabled = $0
        }
        
        viewModel.outputImageIndex.bind { index in
            guard let index else { return }
            UserDefaultsManager.user.image = index
        }
    }
}

private extension ProfileViewController {
    @objc func completeButtonTapped() {
        guard let nickname = nicknameTextField.text else { return }
        viewModel.inputValidNickname.value = nickname
    }
    
    @objc func profileImageTapped() {
//        let vc = ProfileImageViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    @objc func textFieldDidChage(_ textField: UITextField) {
        viewModel.inputText.value = textField.text
    }
}
