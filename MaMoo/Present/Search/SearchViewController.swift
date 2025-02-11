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
    let viewModel = SearchViewModel()
    var contents: (([String]?) -> Void)?
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        configureAction()
        bindData()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindData() {
        viewModel.output.likeDictionary.bind { [weak self] dict in
            print("output.likeDictionary.bind")
            self?.searchView.collectionView.reloadData() // 셀 하나만 리로드
        }
        viewModel.output.movieList.lazyBind { [weak self] list in
            print("output.movieList.lazyBind")
            self?.searchView.noResultLabel.isHidden = list.isEmpty ? false : true
            self?.searchView.collectionView.reloadData()
        }
        viewModel.output.isScroll.lazyBind { [weak self] _ in
            print("output.isScroll.lazyBind")
            self?.searchView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.output.movieList.value.isEmpty {
            searchView.searchBar.becomeFirstResponder()
        }
    }

    private func configureNavigationBar() {
        navigationItem.title = "영화 검색"
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftItemTapped))
        leftItem.tintColor = .maMooPoint
        navigationItem.leftBarButtonItem = leftItem
    }
    
    private func configureView() {
        searchView.searchBar.delegate = self
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.prefetchDataSource = self
        searchView.collectionView.register(SearchViewCollectionViewCell.self, forCellWithReuseIdentifier: SearchViewCollectionViewCell.identifier)
    }
    
    private func configureAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(likeNotification), name: .likeNotification, object: nil)
        searchView.collectionView.keyboardDismissMode = .onDrag
    }
    
    
    @objc private func leftItemTapped() {
        contents?(UserDefaultsManager.shared.searchResults)
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func likeNotification(value: NSNotification) {
        viewModel.input.likeNotification.value = value
    }
    
    
    
}

// MARK: Pagenation UICollectionViewDataSourcePrefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.input.prefetchItem.value = indexPaths
    }
}

// MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.isSearchButtonTapped.value = searchView.searchBar.text
        view.endEditing(true)
    }
}

// MARK: CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.movie = viewModel.output.movieList.value[indexPath.item]
        view.endEditing(true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.movieList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCollectionViewCell.identifier, for: indexPath) as? SearchViewCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.output.movieList.value[indexPath.item]
        let isLiked = viewModel.output.likeDictionary.value[String(movie.id), default: false]
        cell.configureData(movie, isLiked)
        return cell
    }
}
