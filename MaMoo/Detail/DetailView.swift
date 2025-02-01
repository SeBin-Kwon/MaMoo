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
    
    lazy var moreButton = {
        let btn = UIButton()
        btn.configuration = configureMoreButton("More")
        return btn
    }()
    
    private lazy var castLabel = configureLabel("Cast")
    lazy var castCollectionView = configureCastFlowLayout()
    private lazy var posterLabel = configureLabel("Poster")
    lazy var posterCollectionView = configurePosterFlowLayout()
    
    override func configureHierarchy() {
        addSubview(backdropScrollView)
        addSubview(pageControl)
        addSubview(smallLabelStackView)
        addSubview(synopsisLabel)
        addSubview(synopsisLine)
        addSubview(moreButton)
        addSubview(castLabel)
        addSubview(castCollectionView)
        addSubview(posterLabel)
        addSubview(posterCollectionView)
    }
    override func configureLayout() {
        backdropScrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(280)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropScrollView.snp.bottom).inset(10)
        }
        smallLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(backdropScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(smallLabelStackView.snp.bottom).offset(20)
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
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLine.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(110)
        }
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(150)
        }
    }
    
    private func configureInfoLabelButton(image: String, contents: String) -> UIButton {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString(contents)
        attributedTitle.font = .systemFont(ofSize: 12)
        attributedTitle.foregroundColor = UIColor.maMooGray
        config.attributedTitle = attributedTitle
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 11)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.image = UIImage(systemName: image)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.baseForegroundColor = UIColor.maMooGray
        btn.configuration = config
        return btn
    }
    
    func configureSynopsis(_ text: String) {
        synopsisLine.text = text
    }
    
    private func configureinfoLine() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "|"
        return label
    }
    
    func configureInfoData(_ date: String, _ vote: Double, _ genre: [Int]) {
        let dateLabel = configureInfoLabelButton(image: "calendar", contents: date)
        let voteLabel = configureInfoLabelButton(image: "star.fill", contents: String(vote))
        var string = ""
        guard !genre.isEmpty else { return }
        let count = genre.count > 1 ? 2 : 1
        for i in 0..<count {
            guard let genre = Genre.genreDictionary[genre[i]] else { break }
            if i == count-1 {
                string += "\(genre)"
            } else {
                string += "\(genre), "
            }
        }
        let genreLabel = configureInfoLabelButton(image: "film.fill", contents: string)
        smallLabelStackView.addArrangedSubview(dateLabel)
        smallLabelStackView.addArrangedSubview(configureinfoLine())
        smallLabelStackView.addArrangedSubview(voteLabel)
        smallLabelStackView.addArrangedSubview(configureinfoLine())
        smallLabelStackView.addArrangedSubview(genreLabel)
    }
    
    func configureMoreButton(_ title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        attributedTitle.foregroundColor = UIColor.maMooPoint
        config.attributedTitle = attributedTitle
        return config
    }
    
    private func configureCastFlowLayout() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellCount: CGFloat = 2.5
        let lineSpacing: CGFloat = 20
        let itemSpacing: CGFloat = 5
        let insetSpacing: CGFloat = 10
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*2)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: 50)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        return view
    }
    
    private func configurePosterFlowLayout() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellCount: CGFloat = 3.5
        let itemSpacing: CGFloat = 10
        let insetSpacing: CGFloat = 10
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: cellWidth / cellCount * 2)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        return view
    }
    
    private func configureLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }

}
