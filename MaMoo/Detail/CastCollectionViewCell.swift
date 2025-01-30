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
        image.backgroundColor = .yellow
        image.clipsToBounds = true
        return image
    }()
    private let nameLabel = {
        let label = UILabel()
        label.text = "sdfsdf"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    private let engNameLabel = {
        let label = UILabel()
        label.text = "sdfseeewewwe"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    let uiView = {
        let view = UIView()
         return view
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        uiView.addSubview(nameLabel)
        uiView.addSubview(engNameLabel)
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
        }
        engNameLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(uiView)
        }
    }
    
//    func configureData(_ item: String) {
//
//    }
    
//    override func layoutSubviews() {
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//    }
}
