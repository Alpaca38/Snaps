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
        tabBar.tintColor = .black
        
        let topic = UINavigationController(rootViewController: TopicPhotoViewController())
        topic.tabBarItem = UITabBarItem(title: "토픽", image: Image.tabTrendInactive, selectedImage: Image.tabTrend)
        
        let random = UINavigationController(rootViewController: RandomPhotoViewController())
        random.tabBarItem = UITabBarItem(title: "랜덤 사진", image: Image.tabRandomInactive, selectedImage: Image.tabRandom)
        
        let search = UINavigationController(rootViewController: SearchPhotoViewController())
        search.tabBarItem = UITabBarItem(title: "검색", image: Image.tabSearchInActive, selectedImage: Image.tabSearch)
        
        let like = UINavigationController(rootViewController: LikesViewController())
        like.tabBarItem = UITabBarItem(title: "찜", image: Image.tabLikeInactive, selectedImage: Image.tabLike)
        
        setViewControllers([topic, random, search, like], animated: true)
    }
    
}
