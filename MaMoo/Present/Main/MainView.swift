//
//  MainView.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    let profileEditButton = ProfileEditButton()
    private lazy var searchTitleLabel = configureTitleLabel("최근검색어")
    let allRemoveButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString("전체 삭제")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        attributedTitle.foregroundColor = UIColor.maMooPoint
        config.attributedTitle = attributedTitle
        btn.configuration = config
        return btn
    }()
    lazy var searchCollectionView = configureSearchCollectionView()
    private lazy var todayTitleLabel = configureTitleLabel("오늘의 영화")
    lazy var collectionView = configureCollectionView()
    let isSearchLabel = {
        let label = UILabel()
        label.text = "최근 검색어 내역이 없습니다."
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .maMooGray
        label.isHidden = false
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(profileEditButton)
        addSubview(searchTitleLabel)
        addSubview(allRemoveButton)
        addSubview(searchCollectionView)
        addSubview(todayTitleLabel)
        addSubview(collectionView)
        addSubview(isSearchLabel)
    }
    
    override func configureLayout() {
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(140)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
        }
        allRemoveButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTitleLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(38)
        }
        todayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayTitleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        isSearchLabel.snp.makeConstraints { make in
            make.center.equalTo(searchCollectionView)
        }
    }
    
    private func configureSearchCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: 96, height: 33)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        return view
    }
    
    private func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellCount: CGFloat = 1.7
        let itemSpacing: CGFloat = 20
        let insetSpacing: CGFloat = 10
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: -30, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: cellWidth)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .black
        return view
    }
    
    private func configureTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }
}
