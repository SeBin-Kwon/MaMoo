//
//  ProfileViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    private var num = Int.random(in: 0...11)
    private lazy var profileImageButton = ProfileImageButton(num: num)
    
    private let textField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private let button = MaMooButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "프로필 설정"
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
    }
    
    @objc private func profileImageButtonTapped() {
        let vc = ProfileImageViewController()
        vc.num = num
        vc.contents = { value in
            guard let value else { return }
            self.profileImageButton.profileImageView.image = UIImage(named: "profile_\(value)")
            self.num = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureView() {
        view.addSubview(profileImageButton)
        view.addSubview(textField)
        view.addSubview(button)
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
        }
    }

}

extension ProfileViewController: UITextFieldDelegate {
    
}
