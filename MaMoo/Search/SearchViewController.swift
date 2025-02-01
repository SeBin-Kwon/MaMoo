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
    var searchText: String?
    private var previousSearchText: String?
    private var likeDictionary = [String:Bool]()
    private var isSearch = false
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영화 검색"
        searchView.searchBar.delegate = self
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.prefetchDataSource = self
        searchView.collectionView.register(SearchViewCollectionViewCell.self, forCellWithReuseIdentifier: SearchViewCollectionViewCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(likeNotification), name: .likeNotification, object: nil)
        likeDictionary = UserDefaultsManager.shared.like
        searchView.collectionView.keyboardDismissMode = .onDrag
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if movieList.isEmpty {
            searchView.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let searchText {
            searchView.searchBar.text = searchText
            isEnd = false
            isSearch = false
            previousSearchText = searchText
            self.searchText = searchText
            callRequest(query: searchText, page: page)
        }
    }
    
    @objc func likeNotification(value: NSNotification) {
        guard let id = value.userInfo!["id"] as? String,
              let like = value.userInfo!["like"] as? Bool else { return }
        likeDictionary[id] = like
        UserDefaultsManager.shared.like[id] = like
        searchView.collectionView.reloadData()
        print("like신호받음", likeDictionary)
    }
    
    private func callRequest(query: String, page: Int) {
        print("search", #function)
        NetworkManager.shared.fetchResults(api: TMDBRequest.search(value: SearchRequest(query: query, page: page)), type: Movie.self) { value in
            if value.results.isEmpty {
                self.searchView.noResultLabel.isHidden = false
                self.movieList = []
                self.searchView.collectionView.reloadData()
                return
            }
            self.searchView.noResultLabel.isHidden = true
            if page == 1 {
                self.movieList = value.results
            } else {
                self.movieList.append(contentsOf: value.results)
            }
            if value.total_pages == page {
                self.isEnd = true
            }
            for movie in value.results {
                let id = String(movie.id)
                if let likeState = UserDefaultsManager.shared.like[String(id)] {
                    self.likeDictionary[id] = likeState
                }
            }
            
            self.searchView.collectionView.reloadData()
            if self.isSearch && !self.movieList.isEmpty {
                self.searchView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            print("현재 페이지", page)
            print("전체 검색 수", value.total_results)
            print("총 페이지 수", value.total_pages)
        } failHandler: {
            print("fail")
        }
    }
    
}

// MARK: Pagenation UICollectionViewDataSourcePrefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if !isEnd && movieList.count-2 == indexPath.item {
                page += 1
                guard let searchText else { return }
                callRequest(query: searchText, page: page)
            }
        }
        
    }
}

// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchView.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if searchText.isEmpty {
            page = 1
            isEnd = false
            isSearch = true
            callRequest(query: searchText, page: page)
            return
        }
        view.endEditing(true)
        if let previousSearchText {
            guard searchText != previousSearchText else { return }
        }
        page = 1
        isEnd = false
        previousSearchText = searchText
        self.searchText = searchText
        isSearch = true
        callRequest(query: searchText, page: page)
        UserDefaultsManager.shared.searchResults.append(searchText)
    }
}

// MARK: CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.movie = movieList[indexPath.item]
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCollectionViewCell.identifier, for: indexPath) as? SearchViewCollectionViewCell else { return UICollectionViewCell() }
        let movie = movieList[indexPath.item]
        cell.configureData(movie)
        let isLiked = likeDictionary[String(movie.id), default: false]
        cell.updateLikeButton(isLiked)
        return cell
    }
}
