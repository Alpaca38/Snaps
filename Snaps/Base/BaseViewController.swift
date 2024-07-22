//
//  BaseViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        navigationController?.navigationBar.tintColor = Color.black
        navigationItem.backButtonDisplayMode = .minimal
        
        configureLayout()
    }
    
    func configureLayout() { }
}
