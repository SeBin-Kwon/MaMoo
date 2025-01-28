//
//  SearchViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        
    }
    
    override func configureView() {
        print(#function)
    }

}
