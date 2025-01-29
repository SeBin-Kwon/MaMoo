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
    private var movieList = [MovieResults]()
    private var page = 1
    private var isEnd = false
    private var searchText: String?
    private var previousSearchText: String?
    private var isLatest = false
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        searchView.searchBar.delegate = self
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(SearchViewCollectionViewCell.self, forCellWithReuseIdentifier: SearchViewCollectionViewCell.identifier)
    }
    
    private func callRequest(query: String, page: Int) {
//        let group = DispatchGroup()
//        group.enter()
        NetworkManager.shared.fetchResults(api: TMDBRequest.search(value: SearchRequest(query: query, page: page)), type: Movie.self) { value in
            print(value.results.count)
            self.movieList = value.results
            self.searchView.collectionView.reloadData()
//            group.leave()
        } failHandler: {
            print("fail")
//            group.leave()
        }
//        group.notify(queue: .main) {
//            print(#function, "-END-")
//            self.mainView.collectionView.reloadData()
//        }
    }
    
    override func configureView() {
        print(#function)
    }
    
    func configureTag() -> UIButton {
        let btn = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .mini
        config.cornerStyle = .small
        var attributedTitle = AttributedString("장르")
        attributedTitle.font = .systemFont(ofSize: 12)
        attributedTitle.foregroundColor = .white
        config.attributedTitle = attributedTitle
        config.baseBackgroundColor = .darkGray
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        btn.configuration = config
        return btn
    }

}

// MARK: Pagenation - UICollectionViewDataSourcePrefetching
//extension SearchViewController: UICollectionViewDataSourcePrefetching {
//    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//
//        for indexPath in indexPaths {
//            if !isEnd && list.count-2 == indexPath.item || list.count-3 == indexPath.item {
//                page += 1
//                guard let searchText else { return }
//                callRequest(query: searchText, page: page, order: isLatest)
//            }
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        print(#function)
//    }
//}

// MARK: UISearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchView.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        view.endEditing(true)
        if let previousSearchText {
            guard searchText != previousSearchText else { return }
        }
        page = 1
        isEnd = false
        previousSearchText = searchText
        self.searchText = searchText
        callRequest(query: searchText, page: page)
    }
}

// MARK: UICollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCollectionViewCell.identifier, for: indexPath) as? SearchViewCollectionViewCell else { return UICollectionViewCell() }
        cell.configureData(movieList[indexPath.item])
//        for _ in 0..<2 {
//            cell.genreStackView.addArrangedSubview(configureTag())
//        }
        return cell
    }
    
    
}
