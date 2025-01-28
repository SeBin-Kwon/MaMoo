//
//  MainView.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit

class MainView: BaseView {
    let profileEditButton = ProfileEditButton()
    private lazy var searchTitleLabel = configureTitleLabel("최근검색어")
    let allRemoveButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("전체 삭제")
        attributedTitle.font = .systemFont(ofSize: 13, weight: .bold)
        attributedTitle.foregroundColor = UIColor.maMooPoint
        config.attributedTitle = attributedTitle
        btn.configuration = config
        return btn
    }()
    let searchStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .red
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.isUserInteractionEnabled = true
        return stack
    }()
    private let scrollView = {
       let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        scroll.backgroundColor = .blue
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    private lazy var todayTitleLabel = configureTitleLabel("오늘의 영화")
//    let collectionView = UICollectionView()
    
    override func configureHierarchy() {
        addSubview(profileEditButton)
        addSubview(searchTitleLabel)
        addSubview(allRemoveButton)
        scrollView.addSubview(searchStackView)
        addSubview(scrollView)
        addSubview(todayTitleLabel)
//        addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(140)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
        }
        allRemoveButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTitleLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
//            make.height.equalTo(30)
        }
        searchStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView)
            make.height.equalTo(scrollView.snp.height)
        }
        todayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
        }
    }
    
    private func configureTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }
}
