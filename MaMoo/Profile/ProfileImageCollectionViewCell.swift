//
//  ProfileImageCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    var profileImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.maMooGray.cgColor
        image.alpha = 0.5
        return image
    }()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateSelectedCell(_ isSelected: Bool) {
        profileImageView.alpha = isSelected ? 1.0 : 0.5
        profileImageView.layer.borderColor = isSelected ? UIColor.maMooPoint.cgColor : UIColor.maMooGray.cgColor
        profileImageView.layer.borderWidth = isSelected ? 3 : 1
    }
    
    func configureImageView(index: Int) {
        profileImageView.image = UIImage(named: "profile_\(index)")
    }
}
