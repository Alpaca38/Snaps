//
//  BaseViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        navigationController?.navigationBar.tintColor = Color.black
        navigationItem.backButtonDisplayMode = .minimal
        
        configureLayout()
    }
    
    func configureLayout() { }
}
