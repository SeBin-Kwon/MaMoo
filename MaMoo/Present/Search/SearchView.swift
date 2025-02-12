//
//  SearchView.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit

final class SearchView: BaseView {

    let searchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.searchTextField.textColor = .white
        bar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요", attributes: [.foregroundColor: UIColor.gray])
        bar.searchTextField.leftView?.tintColor = .white
        bar.searchTextField.backgroundColor = UIColor(white: 0.08, alpha: 1)
        return bar
    }()
    lazy var collectionView = configureCollectionView()
    let noResultLabel = {
        let label = UILabel()
        label.text = "원하는 검색결과를 찾지 못했습니다"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .maMooGray
        label.isHidden = true
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(noResultLabel)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        noResultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(collectionView)
            make.top.equalTo(collectionView).inset(150)
        }
    }
    
    private func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let insetSpacing: CGFloat = 10
        let cellWidth = width - (insetSpacing*2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth, height: 115)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .black
        return view
    }
    
}
