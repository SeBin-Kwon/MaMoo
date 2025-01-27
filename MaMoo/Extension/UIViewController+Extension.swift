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
        window.rootViewController = UINavigationController(rootViewController: rootView)
        window.makeKeyAndVisible()
    }
}
