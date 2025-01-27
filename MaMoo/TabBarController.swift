//
//  TabBarController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        tabBar.tintColor = UIColor.maMooPoint
        tabBar.unselectedItemTintColor = UIColor.maMooGray
    }
    
    private func configureTabBarController() {
        let mainNav = UINavigationController(rootViewController: MainViewController())
        mainNav.view.backgroundColor = .black
        mainNav.tabBarItem = UITabBarItem(title: "CINEMA", image: UIImage(systemName: "popcorn"), selectedImage: UIImage(systemName: "popcorn"))
        
        let secondNav = UINavigationController(rootViewController: UIViewController())
        secondNav.view.backgroundColor = .black
        secondNav.tabBarItem = UITabBarItem(title: "UPCOMING", image: UIImage(systemName: "film.stack"), selectedImage: UIImage(systemName: "film.stack"))
        
        let settingNav = UINavigationController(rootViewController: UIViewController())
        settingNav.view.backgroundColor = .black
        settingNav.tabBarItem = UITabBarItem(title: "PROFILE", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle"))
        
        setViewControllers([mainNav, secondNav, settingNav], animated: true)
    }
    
}
