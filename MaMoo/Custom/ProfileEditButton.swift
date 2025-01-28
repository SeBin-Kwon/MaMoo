//
//  ProfileEditButton.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit

final class ProfileEditButton: BaseButton {
    private let backgroundView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        return view
    }()
    
    let profileImage = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.maMooPoint.cgColor
        image.clipsToBounds = true
        return image
    }()
    
    let nicknameLabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let dateLabel = {
        let label = UILabel()
        label.textColor = .maMooLightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let chevron = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.tintColor = .maMooGray
        return image
    }()
    
    private let movieBoxBackgroundView = {
        let view = UIView()
        view.backgroundColor = .maMooPoint
         view.layer.cornerRadius = 20
         return view
     }()
    
    let movieBoxLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0개의 무비박스 보관중"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    override func layoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    private func configureHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(profileImage)
        backgroundView.addSubview(nicknameLabel)
        backgroundView.addSubview(dateLabel)

    }
    private func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.bottom.equalTo(dateLabel.snp.top).offset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
        }
    }
    
}
