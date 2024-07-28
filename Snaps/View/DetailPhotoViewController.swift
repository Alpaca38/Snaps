//
//  DetailPhotoViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/24/24.
//

import UIKit
import SwiftUI
import SnapKit
import Kingfisher
import Toast

final class DetailPhotoViewController: BaseViewController {
    let viewModel = DetailPhotoViewModel()
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.addSubview(contentView)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var contentView = {
        let view = UIView()
        view.addSubview(profileImage)
        view.addSubview(labelStackView)
        view.addSubview(likeButton)
        view.addSubview(photoImageView)
        view.addSubview(infoLabel)
        view.addSubview(sizeStackView)
        view.addSubview(viewsStackView)
        view.addSubview(downloadsStackView)
        view.addSubview(infoStackView)
        view.addSubview(chartLabel)
        view.addSubview(segmentedControl)
        return view
    }()
    
    private lazy var profileImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let profileLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private let photoCreatedLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 13)
        return view
    }()
    
    private lazy var labelStackView = {
        let view = UIStackView(arrangedSubviews: [profileLabel, photoCreatedLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    private lazy var likeButton = {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = Image.likeCircleInactive
        config.title = nil
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    private let photoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let infoLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.text = "정보"
        return view
    }()
    
    private let sizeLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.text = "크기"
        return view
    }()
    
    private let sizeValueLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private lazy var sizeStackView = {
        let view = UIStackView(arrangedSubviews: [sizeLabel, sizeValueLabel])
        view.axis = .horizontal
        view.spacing = 120
        return view
    }()
    
    private let viewsLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.text = "조회수"
        return view
    }()
    
    private let viewsValueLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private lazy var viewsStackView = {
        let view = UIStackView(arrangedSubviews: [viewsLabel, viewsValueLabel])
        view.axis = .horizontal
        return view
    }()
    
    private let downloadsLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.text = "다운로드"
        return view
    }()
    
    private let downloadsValueLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private lazy var downloadsStackView = {
        let view = UIStackView(arrangedSubviews: [downloadsLabel, downloadsValueLabel])
        view.axis = .horizontal
        return view
    }()
    
    private lazy var infoStackView = {
        let view = UIStackView(arrangedSubviews: [sizeStackView, viewsStackView, downloadsStackView])
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private let chartLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        view.text = "차트"
        return view
    }()
    
    private lazy var segmentedControl = {
        let items = ["조회", "다운로드"]
        let control = UISegmentedControl(items: items)
        control.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let chartController = UIHostingController(rootView: AreaChart())
    
    override func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.size.equalTo(40)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImage)
            $0.height.equalTo(profileImage).multipliedBy(0.95)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel)
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setupChart() // if iOS 16+
        bindData()
    }
}
// MARK: UI
private extension DetailPhotoViewController {
    func setNavi() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupChart() {
        if #available(iOS 16.0, *) {
            infoStackView.snp.remakeConstraints {
                $0.top.equalTo(infoLabel)
                $0.trailing.equalToSuperview().inset(20)
            }
            
            chartLabel.snp.makeConstraints {
                $0.top.equalTo(infoStackView.snp.bottom).offset(20)
                $0.leading.equalTo(infoLabel)
            }
            
            segmentedControl.snp.makeConstraints {
                $0.top.equalTo(chartLabel)
                $0.leading.equalTo(infoStackView)
            }
            
            addChild(chartController)
            contentView.addSubview(chartController.view)
            chartController.view.snp.makeConstraints {
                $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
                $0.horizontalEdges.equalTo(infoStackView)
                $0.bottom.equalToSuperview().inset(20)
            }
            chartController.didMove(toParent: self)
        }
    }
}

// MARK: Action
private extension DetailPhotoViewController {
    @objc func likeButtonTapped(_ sender: UIButton) {
        viewModel.inputLikeButtonTapped.value = viewModel.outputPhotoData.value
        guard let photoItem = viewModel.outputPhotoData.value, let photoImage = photoImageView.image, let profileImage = profileImage.image else { return }
        if UserDefaultsManager.likeList.contains(photoItem.id) {
            UserDefaultsManager.likeList.remove(photoItem.id)
            removeImageFromDocument(filename: photoItem.id)
            removeImageFromDocument(filename: photoItem.user.id)
        } else {
            UserDefaultsManager.likeList.insert(photoItem.id)
            saveImageToDocument(image: photoImage, filename: photoItem.id)
            saveImageToDocument(image: profileImage, filename: photoItem.user.id)
        }
    }
    
    @objc func segmentControlValueChanged() {
        guard let data = viewModel.outputStatistics.value else { return }
        updateChartData(data: data)
    }
    
    private func updateChartData(data: Statistics) {
        var chartData: [ChartData] = []
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            chartData = data.views.historical.chartData
        case 1:
            chartData = data.downloads.historical.chartData
        default:
            chartData = []
        }
        chartController.rootView = AreaChart(data: chartData)
    }
}

// MARK: Data bind
private extension DetailPhotoViewController {
    func bindData() {
        viewModel.outputPhotoData.bind { [weak self] photoItem in
            guard let photoItem else { return }
            self?.configureUI(photoItem: photoItem)
        }
        
        viewModel.outputLikedPhotoData.bind { [weak self] likedItem in
            guard let likedItem else { return }
            self?.configureUI(likedItem: likedItem)
        }
        
        viewModel.outputSetLike.bind { [weak self] isLike in
            guard let self, let isLike else { return }
            isLike ? likeButton.setImage(Image.like, for: .normal) : likeButton.setImage(Image.likeInactive, for: .normal)
        }
        
        viewModel.outputStatistics.bind { [weak self] data in
            guard let self, let data else { return }
            configureInfo(data: data)
            updateChartData(data: data)
        }
        
        viewModel.outputStatisticsError.bind { [weak self] error in
            self?.view.makeToast(error?.rawValue, position: .center)
        }
    }
    
    func configureUI(photoItem: PhotoItem) {
        let profileURL = URL(string: photoItem.user.profileImage.medium)
        profileImage.kf.setImage(with: profileURL)
        
        profileLabel.text = photoItem.user.name
        
        photoCreatedLabel.text = photoItem.koreanDate
        
        if UserDefaultsManager.likeList.contains(photoItem.id) {
            likeButton.setImage(Image.like, for: .normal)
        } else {
            likeButton.setImage(Image.likeInactive, for: .normal)
        }
        
        let photoImageURL = URL(string: photoItem.urls.small)
        photoImageView.kf.setImage(with: photoImageURL)
        
        let dynamicHeight = UIScreen.main.bounds.width * CGFloat(photoItem.height) / CGFloat(photoItem.width)
        photoImageView.snp.updateConstraints {
            $0.height.equalTo(dynamicHeight)
        }
        
        sizeValueLabel.text = photoItem.size
    }
    
    func configureUI(likedItem: LikeItems) {
        profileImage.image = loadImageToDocument(filename: likedItem.photoGrapherID)
        
        profileLabel.text = likedItem.photoGrapherName
        
        photoCreatedLabel.text = likedItem.koreanDate
        
        if UserDefaultsManager.likeList.contains(likedItem.id) {
            likeButton.setImage(Image.like, for: .normal)
        } else {
            likeButton.setImage(Image.likeInactive, for: .normal)
        }
        
        photoImageView.image = loadImageToDocument(filename: likedItem.id)
        
        let dynamicHeight = UIScreen.main.bounds.width * CGFloat(likedItem.height) / CGFloat(likedItem.width)
        photoImageView.snp.updateConstraints {
            $0.height.equalTo(dynamicHeight)
        }
        
        sizeValueLabel.text = likedItem.size
    }
    
    func configureInfo(data: Statistics) {
        viewsValueLabel.text = data.views.total.formatted()
        downloadsValueLabel.text = data.downloads.total.formatted()
    }
}
