//
//  SearchViewCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .gray
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "sdfsdfsdf"
        label.textColor = .white
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let likeButton = {
        let btn = UIButton()
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
        view.backgroundColor = .maMooGray
        return view
    }()
    
    private let genreDictionary: [Int: String] = [
        28: "액션", 16: "애니메이션", 80: "범죄", 18: "드라마", 14: "판타지",
        27: "공포", 9648: "미스터리", 878: "SF", 53: "스릴러", 37: "서부",
        12: "모험", 35: "코미디", 99: "다큐멘터리", 10751: "가족", 36: "역사",
        10402: "음악", 10749: "로맨스", 10770: "TV 영화", 10752: "전쟁"
    ]
    
    func configureData(_ item: MovieResults) {
        if !genreStackView.arrangedSubviews.isEmpty {
            genreStackView.removeAll()
        }
        if let poster = item.poster_path {
            let newUrl = "https://image.tmdb.org/t/p/w500" + poster
            guard let url = URL(string: newUrl) else { return }
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "xmark.rectangle")
        }
        titleLabel.text = item.title
        dateLabel.text = DateFormatterManager.shared.dateChanged(item.release_date ?? "")
        guard let genreList = item.genre_ids else { return }
        guard !genreList.isEmpty else { return }
        let count = genreList.count > 1 ? 2 : 1
        for i in 0..<count {
            guard let genre = genreDictionary[genreList[i]] else { break }
            genreStackView.addArrangedSubview(configureTag(genre))
        }
    }
    
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
    
    override func configureHierarchy() {
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
            make.size.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        genreStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.bottom.equalTo(imageView.snp.bottom)
        }
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(1)
        }
    }
}
