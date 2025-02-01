//
//  DetailViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: BaseViewController {
    
    private let detailView = DetailView()
    var movie: MovieResults?
    private var backdropsList = [Backdrops]()
    private var isHide = true
    private var castList = [Cast]()
    private var posterList = [Posters]()
    private var likeState = false
    private var id: String?
    private let scrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(detailView)
        configureLayout()
        configureDelegate()
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightItemTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
        detailView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movie else { return }
        navigationItem.title = movie.title
        guard let date = movie.release_date,
              let vote = movie.vote_average,
              let genre = movie.genre_ids else { return }
        self.detailView.configureInfoData(date, vote, genre)
        detailView.configureSynopsis(movie.overview ?? "")
        id = String(movie.id)
        updateLikeButton(UserDefaultsManager.shared.like[String(movie.id), default: false])
        callRequest()
    }
    
    private func configureDelegate() {
        detailView.backdropScrollView.delegate = self
        detailView.castCollectionView.delegate = self
        detailView.castCollectionView.dataSource = self
        detailView.castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        detailView.posterCollectionView.delegate = self
        detailView.posterCollectionView.dataSource = self
        detailView.posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        detailView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
    }
    
    @objc func rightItemTapped() {
        print(#function)
        guard let id else { return }
        likeState.toggle()
        updateLikeButton(likeState)
        UserDefaultsManager.shared.like[id] = likeState
        NotificationCenter.default.post(name: .likeNotification, object: nil, userInfo: ["id": id , "like": likeState])
    }
    
    func updateLikeButton(_ isSelected: Bool) {
        guard let rightItem = navigationItem.rightBarButtonItem else { return }
        rightItem.image = isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeState = isSelected
    }
    
    @objc private func moreButtonTapped() {
        isHide.toggle()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) { [self] in
            detailView.synopsisLine.alpha = 0
            detailView.synopsisLine.numberOfLines = isHide ? 3 : 0
            detailView.moreButton.configuration = isHide ? detailView.configureMoreButton("More") : detailView.configureMoreButton("Hide")
            detailView.synopsisLine.alpha = 1
            view.layoutIfNeeded()
        }
    }
    
    private func callRequest() {
        guard let movie else { return }
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.fetchResults(api: TMDBRequest.detailImage(id: movie.id), type: MovieImage.self) { value in
            if !value.backdrops.isEmpty {
                let count = min(value.backdrops.count, 5)
                self.backdropsList = Array(value.backdrops[0..<count])
                self.configureBackdropScrollView()
            }
            self.posterList = value.posters
            group.leave()
        } failHandler: {
            print("fail")
            group.leave()
        }
        group.notify(queue: .main) {
            print(#function, "-posterEND-")
            self.detailView.posterCollectionView.reloadData()
        }
        
        group.enter()
        NetworkManager.shared.fetchResults(api: .Credit(id: movie.id), type: Casts.self) { value in
            print("cast success")
            self.castList = value.cast
            group.leave()
        } failHandler: {
            print("fail")
            group.leave()
        }
        group.notify(queue: .main) {
            print(#function, "-castEND-")
            self.detailView.castCollectionView.reloadData()
        }
        
    }
    
    private func configureBackdropScrollView() {
        for i in 0..<backdropsList.count {
            var imageView = UIImageView()
            if let image = backdropsList[i].file_path {
                let newUrl = "https://image.tmdb.org/t/p/w500" + image
                guard let url = URL(string: newUrl) else { return }
                imageView = configureImage()
                imageView.kf.setImage(with: url)
                imageView.contentMode = .scaleAspectFill
            } else {
                imageView.image = UIImage(systemName: "xmark")
                imageView.contentMode = .center
                imageView.tintColor = .black
            }
            
            let xPos = view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: detailView.backdropScrollView.bounds.width, height: detailView.backdropScrollView.bounds.height)
            detailView.backdropScrollView.addSubview(imageView)
            detailView.backdropScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            detailView.pageControl.numberOfPages = backdropsList.count
        }
    }
    
    
    private func configureImage() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .darkGray
        return image
    }
}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailView.castCollectionView {
            castList.count
        } else {
            posterList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailView.castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(castList[indexPath.item])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(posterList[indexPath.item])
            return cell
        }
        
    }
    
    
}

// MARK: ScrollView
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        detailView.pageControl.currentPage = Int(pageNumber)
    }
}
