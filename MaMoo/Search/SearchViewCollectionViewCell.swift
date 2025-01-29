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
    
    func configureData(_ item: MovieResults) {
        let newUrl = "https://image.tmdb.org/t/p/w500" + item.poster_path
        guard let url = URL(string: newUrl) else { return }
        imageView.kf.setImage(with: url)
        titleLabel.text = item.title
        dateLabel.text = DateFormatterManager.shared.dateChanged(item.release_date)
    }
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(likeButton)
        addSubview(lineView)
//        genreStackView.addArrangedSubview(genreTag)
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
