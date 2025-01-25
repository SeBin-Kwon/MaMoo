//
//  ProfileImageButton.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageButton: UIButton {
    private let num: Int
    
    lazy var profileImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profile_\(num)")
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.maMooPoint.cgColor
        image.clipsToBounds = true
        image.frame = .init(x: 0, y: 0, width: 100, height: 100)
        return image
    }()
    
    private let cameraImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.fill")
        image.tintColor = .white
        return image
    }()
    
    let cameraBackgroundView = {
        let view = UIView()
        view.backgroundColor = .maMooPoint
        view.clipsToBounds = true
        view.frame = .init(x: 0, y: 0, width: 28, height: 28)
        return view
    }()
    
    init(num: Int?) {
        self.num = num ?? 0
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(cameraBackgroundView)
        cameraBackgroundView.addSubview(cameraImageView)
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        cameraBackgroundView.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.centerX.equalTo(profileImageView).offset(30)
            make.bottom.equalTo(profileImageView)
        }
        cameraImageView.snp.makeConstraints { make in
            make.size.equalTo(17)
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        cameraBackgroundView.layer.cornerRadius = cameraBackgroundView.frame.height / 2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
