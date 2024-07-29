//
//  Extension+UIViewController.swift
//  Snaps
//
//  Created by 조규연 on 7/29/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, buttonTitle: String, buttonStyle: UIAlertAction.Style = .default, preferredStyle: UIAlertController.Style = .alert, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let button = UIAlertAction(title: buttonTitle, style: buttonStyle) { _ in
            completion()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(button)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
