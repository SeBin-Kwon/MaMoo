//
//  MainViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: BaseViewController {
    
    private let profileEditButton = ProfileEditButton()
//    private let mainView = MainView()
//    override func loadView() {
//        view = mainView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MAMOO"
        configureView()
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightItemTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
        
        
        profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        
        
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value.results.count)
        } failHandler: {
            print("fail")
        }
    }
    
    @objc func rightItemTapped() {
        print(#function)
    }
    
    

    override func configureView() {
        view.addSubview(profileEditButton)
        

        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        
    }
}
