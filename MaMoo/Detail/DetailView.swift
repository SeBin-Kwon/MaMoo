//
//  DetailView.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit

class DetailView: BaseView {
    
    let pageControl = {
       let page = UIPageControl()
        page.currentPage = 0
        page.hidesForSinglePage = true
        return page
    }()
    let backdropScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let voteLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let genreLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let smallLabelStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var synopsisLabel = configureLabel("Synopsis")
    
    let synopsisLine = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    let moreButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("More")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        attributedTitle.foregroundColor = .maMooPoint
        config.attributedTitle = attributedTitle
        btn.configuration = config
        return btn
    }()
    
    private lazy var castLabel = configureLabel("Cast")
    private lazy var posterLabel = configureLabel("Poster")
    
    override func configureHierarchy() {
        addSubview(backdropScrollView)
        addSubview(pageControl)
        smallLabelStackView.addArrangedSubview(dateLabel)
        smallLabelStackView.addArrangedSubview(voteLabel)
        smallLabelStackView.addArrangedSubview(genreLabel)
        addSubview(smallLabelStackView)
        addSubview(synopsisLabel)
        addSubview(synopsisLine)
        addSubview(moreButton)
    }
    override func configureLayout() {
        backdropScrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(400)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropScrollView.snp.bottom).inset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing)
        }
        genreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(voteLabel.snp.trailing)
        }
        smallLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(backdropScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(smallLabelStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        synopsisLine.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(synopsisLabel)
        }
    }
    
    
    func configureSynopsis(_ text: String) {
        synopsisLine.text = text
    }
    
    func configureSmallLabel(_ date: String, _ vote: Double, _ genre: [Int]) {
//        let dateLabel = UILabel()
        dateLabel.text = " \(date) | "
        dateLabel.addImage(name: "calendar")
//        let voteLabel = UILabel()
        voteLabel.text = " \(vote) | "
        voteLabel.addImage(name: "star.fill")
        guard !genre.isEmpty else { return }
        let count = genre.count > 1 ? 2 : 1
        for i in 0..<count {
            guard let genre = Genre.genreDictionary[genre[i]] else { break }
            genreLabel.text = (genreLabel.text ?? "") + " " + genre
        }
//        genreLabel.text = " \(vote) | "
        genreLabel.addImage(name: "film.fill")
//        smallLabel.text = (String(dateLabel.attributedText) ?? "") + (dateLabel.text ?? "")
//        smallLabel.text = (smallLabel.text ?? "") + " some other word(s)"
//        guard let genreList
//        smallLabel.addImage(name: "film.fill")
    }
    
    private func configureLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }

}
