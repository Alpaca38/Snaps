//
//  TabBarController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarController()
    }
    
    func setTabBarController() {
        tabBar.tintColor = .black
        
        var viewControllers: [UIViewController] = []
        
        TabBar.allCases.forEach {
            let tab = UINavigationController(rootViewController: $0.viewController)
            tab.tabBarItem = UITabBarItem(title: $0.title, image: $0.image, selectedImage: $0.selectedImage)
            
            viewControllers.append(tab)
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}

extension TabBarController {
    enum TabBar: CaseIterable {
        case topic
        case random
        case search
        case like
        
        var viewController: UIViewController {
            switch self {
            case .topic:
                return TopicPhotoViewController()
            case .random:
                return RandomPhotoViewController()
            case .search:
                return SearchPhotoViewController()
            case .like:
                return LikesViewController()
            }
        }
        
        var title: String {
            switch self {
            case .topic:
                return "토픽"
            case .random:
                return "랜덤 사진"
            case .search:
                return "검색"
            case .like:
                return "찜"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .topic:
                Image.tabTrendInactive
            case .random:
                Image.tabRandomInactive
            case .search:
                Image.tabSearchInActive
            case .like:
                Image.tabLikeInactive
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .topic:
                Image.tabTrend
            case .random:
                Image.tabRandom
            case .search:
                Image.tabSearch
            case .like:
                Image.tabLike
            }
        }
    }
}
