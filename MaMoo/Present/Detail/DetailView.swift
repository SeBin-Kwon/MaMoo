//
//  DetailView.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit

final class DetailView: BaseView {
    
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
    
//    private let scrollView = {
//        let scroll = UIScrollView()
//        scroll.showsVerticalScrollIndicator = false
//        return scroll
//    }()
    
    private let smallLabelStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
//    private let uiView = UIView()
    
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
    
    lazy var noBackdropLabel = configureNoDataLabel("백드롭 이미지가 없습니다")
    lazy var noSynopsisLabel = configureNoDataLabel("시놉시스 정보가 없습니다")
    lazy var noCastLabel = configureNoDataLabel("배우 정보가 없습니다")
    lazy var noPosterLabel = configureNoDataLabel("포스트 이미지가 없습니다")
    
    private lazy var castLabel = configureLabel("Cast")
    lazy var castCollectionView = configureCastFlowLayout()
    private lazy var posterLabel = configureLabel("Poster")
    lazy var posterCollectionView = configurePosterFlowLayout()
    
    override func configureHierarchy() {
//        addSubview(scrollView)
//        scrollView.addSubview(uiView)
        [backdropScrollView, pageControl, smallLabelStackView, synopsisLabel, synopsisLine, moreButton, castLabel, castCollectionView, posterLabel, posterCollectionView, noBackdropLabel, noSynopsisLabel, noCastLabel, noPosterLabel].forEach {
            addSubview($0)
        }
        
        
        
        
//        addSubview(backdropScrollView)
//        addSubview(pageControl)
//        addSubview(smallLabelStackView)
//        addSubview(synopsisLabel)
//        addSubview(synopsisLine)
//        addSubview(moreButton)
//        addSubview(castLabel)
//        addSubview(castCollectionView)
//        addSubview(posterLabel)
//        addSubview(posterCollectionView)
//        addSubview(noBackdropLabel)
//        addSubview(noSynopsisLabel)
//        addSubview(noCastLabel)
//        addSubview(noPosterLabel)
    }
    override func configureLayout() {
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(safeAreaLayoutGuide)
//        }
//        uiView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView)
//            make.width.equalTo(scrollView.snp.width)
//            make.verticalEdges.equalTo(scrollView)
//        }
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
        noBackdropLabel.snp.makeConstraints { make in
            make.center.equalTo(backdropScrollView)
        }
        noSynopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        noCastLabel.snp.makeConstraints { make in
            make.center.equalTo(castCollectionView)
        }
        noPosterLabel.snp.makeConstraints { make in
            make.center.equalTo(posterCollectionView)
        }
    }
    
    func configureSynopsis(_ text: String) {
        synopsisLine.text = text
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
}

// MARK: Configure UI
extension DetailView {
    
    private func configureNoDataLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .maMooGray
        label.isHidden = true
        return label
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
    
    private func configureinfoLine() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "|"
        return label
    }
    
    func configureMoreButton(_ title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        attributedTitle.foregroundColor = UIColor.maMooPoint
        config.attributedTitle = attributedTitle
        return config
    }
    
    private func configureLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }
}


// MARK: FlowLayout
extension DetailView {
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
}
