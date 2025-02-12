//
//  DetailViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/12/25.
//

import Foundation

class DetailViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    private var id = 0

    struct Input {
        var movie: Observable<MovieResults?> = Observable(nil)
        var isLikeButtonTapped: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        var movie: Observable<MovieResults?> = Observable(nil)
        var movieInfo = Observable(("", 0.0, [Int]()))
        var synopsis = Observable("")
        var likeState = Observable(false)
        var backdropsList = Observable([Backdrops]())
        var castList = Observable([Cast]())
        var posterList = Observable([Posters]())
        var error: Observable<ErrorType?> = Observable(nil)
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.movie.lazyBind { [weak self] value in
            guard let value else { return }
            self?.output.movie.value = value
            self?.id = value.id
            self?.output.likeState.value = UserDefaultsManager.shared.like[String(value.id)] ?? false
            guard let date = value.release_date,
                  let vote = value.vote_average,
                  let genre = value.genre_ids,
                  let synopsis = value.overview else { return }
            self?.output.movieInfo.value = (date, vote, genre)
            self?.output.synopsis.value = synopsis
            self?.callRequest()
        }
        input.isLikeButtonTapped.lazyBind { [weak self] _ in
            self?.likeButtonTapped()
        }
    }
    
    private func likeButtonTapped() {
        output.likeState.value.toggle()
        UserDefaultsManager.shared.like[String(id)] = output.likeState.value
        
        NotificationCenter.default.post(name: .likeNotification, object: nil, userInfo: ["id": String(id) , "like": output.likeState.value])
    }
    
    private func callRequest() {
        NetworkManager.shared.fetchResults(api: TMDBRequest.detailImage(id: id), type: MovieImage.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                var list = [Backdrops]()
                if !value.backdrops.isEmpty {
                    let count = min(value.backdrops.count, 5)
                    list = Array(value.backdrops[0..<count])
                }
                self.output.backdropsList.value = list
                print(list.count)
                self.output.posterList.value = value.posters
            case .failure(let error):
                guard let code = error.responseCode,
                      let errorType = ErrorType(rawValue: code) else { return }
                output.error.value = errorType
            }
        }
        
        NetworkManager.shared.fetchResults(api: .Credit(id: id), type: Casts.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let value):
                self.output.castList.value = value.cast
            case .failure(let error):
                guard let code = error.responseCode,
                      let errorType = ErrorType(rawValue: code) else { return }
                self.output.error.value = errorType
            }
        }
    }
}
