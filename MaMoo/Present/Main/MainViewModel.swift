//
//  MainViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/11/25.
//

import Foundation

class MainViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    var movieList = [MovieResults]()
    
    struct Input {
        var isRemoveButtonTapped: Observable<Int?> = Observable(nil)
        var isAllRemoveButtonTapped: Observable<Void?> = Observable(())
        var likeNotification: Observable<NSNotification?> = Observable(nil)
        var profileNotification: Observable<NSNotification?> = Observable(nil)
    }
    
    struct Output {
        var searchList = Observable(UserDefaultsManager.shared.searchResults)
        var likeDictionary = Observable(UserDefaultsManager.shared.like)
        var likeCount = Observable(0)
        var nickname = Observable(UserDefaultsManager.shared.nickname)
        var profileImage = Observable(UserDefaultsManager.shared.profileImage)
        var reloadCollectionView: Observable<Void?> = Observable(())
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
        updateLikeCount()
        callRequest()
    }
    
    func transform() {
        print(#function)
        input.isAllRemoveButtonTapped.lazyBind { [weak self] _ in
            self?.allRemoveButtonTapped()
        }
        input.isRemoveButtonTapped.bind { [weak self] index in
            self?.removeButtonTapped(index)
        }
        input.likeNotification.lazyBind { [weak self] value in
            self?.likeNotification(value)
            self?.updateLikeCount()
        }
        input.profileNotification.lazyBind { [weak self] value in
            self?.profileNotification(value)
        }
    }
    
    private func callRequest() {
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { [weak self] value in
            self?.movieList = value.results
            group.leave()
        } failHandler: { error in
            print(error)
//            self.displayAlert(title: error.title, message: error.reason, isCancel: false)
            group.leave()
        }
        group.notify(queue: .main) {
            self.output.reloadCollectionView.value = ()
        }
    }
    
    @objc private func likeNotification(_ value: NSNotification?) {
        guard let value else { return }
        print("..likeNotification")
        guard let id = value.userInfo!["id"] as? String,
              let like = value.userInfo!["like"] as? Bool else { return }
        output.likeDictionary.value[id] = like
        UserDefaultsManager.shared.like[id] = like
    }
    
    @objc private func profileNotification(_ value: NSNotification?) {
        guard let value else {
            return
        }
        print("..profileNotification")
        guard let nickname = value.userInfo!["nickname"] as? String,
              let imageNum = value.userInfo!["profileImage"] as? Int else { return }
        output.nickname.value = nickname
        output.profileImage.value = imageNum
    }
    
    private func removeButtonTapped(_ index: Int?) {
        guard let index else { return }
        print("0. viewModel removeButtonTapped")
        output.searchList.value.remove(at: index)
        UserDefaultsManager.shared.searchResults = output.searchList.value
    }
    
    private func allRemoveButtonTapped() {
        output.searchList.value.removeAll()
        UserDefaultsManager.shared.removeObject(key: .searchResults, type: [String].self)
    }
    
    private func updateLikeCount() {
        print(#function)
        output.likeCount.value = UserDefaultsManager.shared.like.filter { $1 == true }.count
    }
    
}
