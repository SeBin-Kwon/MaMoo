//
//  UIViewController+Extension.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit

extension UIViewController {
    static func changeRootViewController(rootView: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        window.backgroundColor = .maMooGray
        if let tabBar = rootView as? TabBarController {
            window.rootViewController = tabBar
        } else {
            window.rootViewController = UINavigationController(rootViewController: rootView)
        }
        window.makeKeyAndVisible()
    }
    
    func displayAlert(title: String, message: String?, isCancel: Bool, _ completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch isCancel {
        case true:
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            present(alert, animated: true)
        case false:
            let okButton = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
}
