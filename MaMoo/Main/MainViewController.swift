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

    let button = UIButton()
//    let nickname = {
//        let label = UILabel()
//        label.text = UserDefaultsManager.shared.nickname
//        label.textColor = .white
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        return label
//    }()
//    var profileImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
//        image.clipsToBounds = true
//        image.layer.borderWidth = 1
//        image.layer.borderColor = UIColor.maMooGray.cgColor
//        image.alpha = 0.5
//        return image
//    }()
    
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
        
        button.setTitle("탈퇴", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value.results.count)
        } failHandler: {
            print("fail")
        }
    }
    
    @objc func rightItemTapped() {
        print(#function)
    }
    
    @objc func buttonTapped() {
        print(#function)
        UserDefaultsManager.shared.isDisplayedOnboarding = false
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }

    override func configureView() {
        view.addSubview(profileEditButton)
        view.addSubview(button)

        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
}
