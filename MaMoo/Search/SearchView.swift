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
        
        return bar
    }()
    
    override func configureHierarchy() {
        addSubview(searchBar)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
