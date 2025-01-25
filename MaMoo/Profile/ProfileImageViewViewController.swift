//
//  ProfileImageViewViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import UIKit
import SnapKit

class ProfileImageViewViewController: BaseViewController {
    
    var num: Int?
    private lazy var profileImageButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "프로필 이미지 설정"
        profileImageButton = ProfileImageButton(num: num)
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func configureView() {
        view.addSubview(profileImageButton)
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
    }

}
