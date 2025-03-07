//
//  MainCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MainCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.backgroundColor = .darkGray
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
        label.textAlignment = .justified
        return label
    }()
    
    let likeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .maMooPoint
        return btn
    }()
    
    private var id: String?
    private var likeState = false
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        guard let id else { return }
        likeState.toggle()
        updateLikeButton(likeState)
        UserDefaultsManager.like[id] = likeState
        NotificationCenter.default.post(name: .likeNotification, object: nil, userInfo: ["id": id , "like": likeState])
    }
    
    func configureData(_ item: MovieResults) {
        if let poster = item.poster_path {
            let url = TMDBImageRequest.big(path: poster).endPoint
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(systemName: "xmark")
            imageView.contentMode = .center
            imageView.tintColor = .black
        }
        titleLabel.text = item.title
        overviewLabel.text = item.overview
        id = String(item.id)
        likeState = UserDefaultsManager.like[String(item.id), default: false]
        updateLikeButton(likeState)
    }
    
    func updateLikeButton(_ isSelected: Bool) {
        likeButton.setImage(isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeState = isSelected
    }
    
    override func configureHierarchy() {
        backgroundColor = .black
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(overviewLabel)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().inset(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().inset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
