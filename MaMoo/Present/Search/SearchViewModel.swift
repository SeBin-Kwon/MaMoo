//
//  SearchViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/11/25.
//

import Foundation

class SearchViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var likeNotification: Observable<NSNotification?> = Observable(nil)
        var isSearchButtonTapped: Observable<String?> = Observable(nil)
        var searchTag: Observable<String?> = Observable(nil)
        var prefetchItem: Observable<[IndexPath]?> = Observable(nil)
    }
    struct Output {
        var likeDictionary = Observable(UserDefaultsManager.like)
        var movieList = Observable([MovieResults]())
        var isScroll: Observable<Void?> = Observable(nil)
        var searchTagText = Observable("")
        var error: Observable<ErrorType?> = Observable(nil)
    }
    
    private var page = 1
    private var isEnd = false
    private var searchText: String?
    private var previousSearchText: String?
    private var isSearch = false
    
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.searchTag.lazyBind { [weak self] text in
            self?.searchTagButtonTapped(text)
        }
        input.isSearchButtonTapped.lazyBind { [weak self] text in
            self?.searchButtonTapped(text)
        }
        input.likeNotification.lazyBind { [weak self] value in
            self?.likeNotification(value)
        }
        input.prefetchItem.lazyBind { [weak self] value in
            self?.prefetchPagenation(value)
        }
    }
    
    private func searchTagButtonTapped(_ text: String?) {
        guard let searchText = text else { return }
        print(#function)
        isEnd = false
        isSearch = false
        previousSearchText = searchText
        self.searchText = searchText
        output.searchTagText.value = searchText
        callRequest(query: searchText, page: page)
    }
    
    private func searchButtonTapped(_ text: String?) {
        guard let searchText = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if searchText.isEmpty {
            page = 1
            isEnd = false
            isSearch = true
            return
        }
        
        if let previousSearchText {
            guard searchText != previousSearchText else { return }
        }
        page = 1
        isEnd = false
        previousSearchText = searchText
        self.searchText = searchText
        isSearch = true
        callRequest(query: searchText, page: page)
        UserDefaultsManager.searchResults.append(searchText)
    }
    
    private func callRequest(query: String, page: Int) {
        NetworkManager.shared.fetchResults(api: TMDBRequest.search(value: SearchRequest(query: query, page: page)), type: Movie.self) { [weak self] response in
            switch response {
            case .success(let value):
                if value.results.isEmpty {
                    self?.output.movieList.value = []
                    return
                }
                if page == 1 {
                    self?.output.movieList.value = value.results
                } else {
                    self?.output.movieList.value.append(contentsOf: value.results)
                }
                
                if value.total_pages == page {
                    self?.isEnd = true
                }
                
                for movie in value.results {
                    let id = String(movie.id)
                    if let likeState = UserDefaultsManager.like[String(id)] {
                        self?.output.likeDictionary.value[id] = likeState
                    }
                }
                guard let self else { return }
                if self.isSearch && !self.output.movieList.value.isEmpty && self.page == 1 {
                    self.output.isScroll.value = ()
                }
            case .failure(let error):
                guard let code = error.responseCode,
                      let errorType = ErrorType(rawValue: code) else { return }
                self?.output.error.value = errorType
            }
        }
        
    }
    
    private func likeNotification(_ value: NSNotification?) {
        guard let value else { return }
        guard let id = value.userInfo!["id"] as? String,
              let like = value.userInfo!["like"] as? Bool else { return }
        output.likeDictionary.value[id] = like
        UserDefaultsManager.like[id] = like
    }
    
    private func prefetchPagenation(_ indexPaths: [IndexPath]?) {
        guard let indexPaths else { return }
        for indexPath in indexPaths {
            if !isEnd && output.movieList.value.count-2 == indexPath.item {
                page += 1
                guard let searchText = self.searchText else { return }
                callRequest(query: searchText, page: page)
            }
        }
    }
}
