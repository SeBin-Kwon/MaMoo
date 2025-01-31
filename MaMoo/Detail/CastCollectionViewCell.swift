//
//  CastCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class CastCollectionViewCell: BaseCollectionViewCell {
    let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    private let nameLabel = {
        let label = UILabel()
        label.text = "sdfsdf"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    private let chrNameLabel = {
        let label = UILabel()
        label.text = "sdfseeewewwe"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .maMooGray
        return label
    }()
    let uiView = {
        let view = UIView()
         return view
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        uiView.addSubview(nameLabel)
        uiView.addSubview(chrNameLabel)
        addSubview(uiView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(50)
        }
        uiView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.height.equalTo(imageView).inset(6)
            make.trailing.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(uiView)
            make.trailing.equalTo(uiView).inset(10)
        }
        chrNameLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(uiView)
            make.trailing.equalTo(uiView).inset(10)
        }
    }
    
    func configureData(_ item: Cast) {
        if let image = item.profile_path {
            let newUrl = "https://image.tmdb.org/t/p/w500" + image
            guard let url = URL(string: newUrl) else { return }
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "xmark.rectangle")
        }
        
        nameLabel.text = item.name
        chrNameLabel.text = item.character
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
}
