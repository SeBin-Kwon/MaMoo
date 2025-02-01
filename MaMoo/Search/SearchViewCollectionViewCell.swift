//
//  SearchViewCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchViewCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .darkGray
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .maMooGray
        return label
    }()
    
    let likeButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium
        btn.configuration = config
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .maMooPoint
        return btn
    }()
    
    let genreStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 3
        return stack
    }()
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    var id: String?
    var likeState = false
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let id else { return }
        likeState.toggle()
        updateLikeButton(likeState)
        UserDefaultsManager.shared.like[id] = likeState
        NotificationCenter.default.post(name: .likeNotification, object: nil, userInfo: ["id": id , "like": likeState])
    }
    
    func configureData(_ item: MovieResults) {
        if !genreStackView.arrangedSubviews.isEmpty {
            genreStackView.removeAll()
        }
        if let poster = item.poster_path {
            let newUrl = "https://image.tmdb.org/t/p/w500" + poster
            guard let url = URL(string: newUrl) else { return }
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(systemName: "xmark")
            imageView.contentMode = .center
            imageView.tintColor = .black
        }
        titleLabel.text = item.title
        dateLabel.text = DateFormatterManager.shared.dateChanged(item.release_date ?? "")
        guard let genreList = item.genre_ids else { return }
        guard !genreList.isEmpty else { return }
        let count = genreList.count > 1 ? 2 : 1
        for i in 0..<count {
            guard let genre = Genre.genreDictionary[genreList[i]] else { break }
            genreStackView.addArrangedSubview(configureTag(genre))
        }
        
        id = String(item.id)
        likeState = UserDefaultsManager.shared.like[String(item.id), default: false]
        updateLikeButton(likeState)
    }
    
    func updateLikeButton(_ isSelected: Bool) {
        likeButton.setImage(isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeState = isSelected
    }
    
    override func configureHierarchy() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(likeButton)
        addSubview(lineView)
        addSubview(genreStackView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(genreStackView)
        }
        genreStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(0.5)
        }
    }
}

// MARK: Comfigure UI
extension SearchViewCollectionViewCell {
    private func configureTag(_ str: String) -> UIButton {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .mini
        config.cornerStyle = .small
        var attributedTitle = AttributedString(str)
        attributedTitle.font = .systemFont(ofSize: 12)
        attributedTitle.foregroundColor = .white
        config.attributedTitle = attributedTitle
        config.baseBackgroundColor = .darkGray
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        btn.configuration = config
        return btn
    }
}
