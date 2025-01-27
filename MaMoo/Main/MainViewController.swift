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
    let nickname = {
        let label = UILabel()
        label.text = UserDefaultsManager.shared.nickname
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    var profileImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.maMooGray.cgColor
        image.alpha = 0.5
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MAMOO"
        configureView()
        button.setTitle("탈퇴", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value)
            print(value.results.count)
        } failHandler: {
            print("fail")
        }
    }
    
    @objc func buttonTapped() {
        print(#function)
        UserDefaultsManager.shared.isDisplayedOnboarding = false
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }

    override func configureView() {
        view.addSubview(nickname)
        view.addSubview(profileImageView)
        view.addSubview(button)
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
}
