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
    private let scrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
//    override func loadView() {
//        view = detailView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(detailView)
        configureLayout()
        detailView.backdropScrollView.delegate = self
        detailView.castCollectionView.delegate = self
        detailView.castCollectionView.dataSource = self
        detailView.castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightItemTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
        detailView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
    
    @objc private func moreButtonTapped() {
        isHide.toggle()
        UIView.animate(withDuration: 0.3) { [self] in
            detailView.synopsisLine.numberOfLines = isHide ? 3 : 0
            detailView.moreButton.configuration?.attributedTitle = isHide ? AttributedString("More") : AttributedString("Hide")
            detailView.moreButton.configuration?.attributedTitle?.font = .systemFont(ofSize: 14, weight: .bold)
            detailView.moreButton.configuration?.attributedTitle?.foregroundColor = .maMooPoint
            view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movie else { return }
        navigationItem.title = movie.title
        guard let date = movie.release_date,
              let vote = movie.vote_average,
              let genre = movie.genre_ids else { return }
        self.detailView.configureSmallLabel(date, vote, genre)
        detailView.configureSynopsis(movie.overview ?? "")
        callRequest()
    }
    
    private func callRequest() {
        guard let movie else { return }
        NetworkManager.shared.fetchResults(api: TMDBRequest.detailImage(id: movie.id), type: MovieImage.self) { value in
            guard !value.backdrops.isEmpty else { return }
            let count = min(value.backdrops.count, 5)
            self.backdropsList = Array(value.backdrops[0..<count])
            self.configureBackdropScrollView()
        } failHandler: {
            print("fail")
        }
    }
    
    private func configureBackdropScrollView() {
        for i in 0..<backdropsList.count {
            let newUrl = "https://image.tmdb.org/t/p/w500" + backdropsList[i].file_path
            guard let url = URL(string: newUrl) else { return }
            let imageView = configureImage()
            imageView.kf.setImage(with: url)
            
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
        image.backgroundColor = .gray
        return image
    }
    
    @objc func rightItemTapped() {
        print(#function)
    }
    
}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .blue
//        cell.configureData(movieList[indexPath.item])
        return cell
    }
    
    
}

// MARK: ScrollView
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        detailView.pageControl.currentPage = Int(pageNumber)
    }
}
