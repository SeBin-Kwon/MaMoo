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
//        page.pageIndicatorTintColor = .red
        return page
    }()
    let backdropScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    
    private lazy var synopsisLabel = configureLabel()
    private lazy var castLabel = configureLabel()
    private lazy var posterLabel = configureLabel()
    
    override func configureHierarchy() {
        addSubview(backdropScrollView)
        addSubview(pageControl)
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
    }
    
    private func configureLabel() -> UILabel {
        let label = UILabel()
        return label
    }

}
