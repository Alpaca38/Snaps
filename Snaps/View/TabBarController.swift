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
        
        let search = UINavigationController(rootViewController: SearchPhotoViewController())
        search.tabBarItem = UITabBarItem(title: "검색", image: Image.tabSearchInActive, selectedImage: Image.tabSearch)
        
        setViewControllers([search], animated: true)
    }
    
}
