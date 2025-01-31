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
        view.backgroundColor = .darkGray.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = false
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
        view.backgroundColor = .maMooPoint.withAlphaComponent(0.6)
         view.layer.cornerRadius = 8
         return view
     }()
    
    let movieBoxLabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0개의 무비박스 보관중"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let uiView = {
        let view = UIView()
         return view
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
        uiView.addSubview(nicknameLabel)
        uiView.addSubview(dateLabel)
        backgroundView.addSubview(uiView)
        backgroundView.addSubview(chevron)
        movieBoxBackgroundView.addSubview(movieBoxLabel)
        addSubview(movieBoxBackgroundView)
        
    }
    private func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.size.equalTo(50)
        }
        uiView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(profileImage).inset(6)
            make.trailing.equalToSuperview().inset(15)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(uiView)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(uiView)
        }
        chevron.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(15)
        }
        movieBoxBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(backgroundView).inset(15)
            make.height.equalTo(40)
        }
        movieBoxLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
