//
//  MainCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit
import Kingfisher

class MainCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let overviewLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let likeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .maMooPoint
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().inset(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
    }
    
    func configureData(_ item: MovieResults) {
        if let poster = item.poster_path {
            let newUrl = "https://image.tmdb.org/t/p/w500" + poster
            guard let url = URL(string: newUrl) else { return }
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "xmark.rectangle")
        }
        
        titleLabel.text = item.title
    }
}
