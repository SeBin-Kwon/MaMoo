//
//  DetailViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: BaseViewController {
    
    let viewModel = DetailViewModel()
    private let detailView = DetailView()
    private var isHide = true
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegate()
        bindData()
        detailView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    private func bindData() {
        viewModel.output.movie.lazyBind { [weak self] value in
            self?.navigationItem.title = value?.title
        }
        viewModel.output.movieInfo.lazyBind { [weak self] (date, vote, genre) in
            self?.detailView.configureInfoData(date, vote, genre)
        }
        viewModel.output.synopsis.lazyBind { [weak self] text in
            self?.detailView.synopsisLine.text = text
            self?.detailView.noSynopsisLabel.isHidden = text.isEmpty ? false : true
            self?.detailView.moreButton.isHidden = text.isEmpty ? true : false
        }
        viewModel.output.likeState.lazyBind { [weak self] value in
            guard let rightItem = self?.navigationItem.rightBarButtonItem else { return }
            rightItem.image = value ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
        viewModel.output.backdropsList.lazyBind { [weak self] value in
            self?.detailView.noBackdropLabel.isHidden = value.isEmpty ? false : true
            self?.configureBackdropScrollView(value)
        }
        viewModel.output.posterList.lazyBind { [weak self] value in
            self?.detailView.noPosterLabel.isHidden = value.isEmpty ? false : true
            self?.detailView.posterCollectionView.reloadData()
        }
        viewModel.output.castList.lazyBind { [weak self] value in
            self?.detailView.noCastLabel.isHidden = value.isEmpty ? false : true
            self?.detailView.castCollectionView.reloadData()
        }
        viewModel.output.error.lazyBind { [weak self] error in
            guard let error else { return }
            self?.displayAlert(title: error.title, message: error.reason, isCancel: false)
        }
    }
    
    private func configureNavigationBar() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
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
    
//    private func configureLayout() {
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//        detailView.snp.makeConstraints { make in
//            make.width.equalTo(scrollView.snp.width)
//            make.verticalEdges.equalTo(scrollView)
//        }
//    }
    
    @objc private func likeButtonTapped() {
        viewModel.input.isLikeButtonTapped.value = ()
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
}

// MARK: Configure UI
extension DetailViewController {
    private func configureBackdropScrollView(_ backdropsList: [Backdrops]) {
        for i in 0..<backdropsList.count {
            var imageView = UIImageView()
            if let image = backdropsList[i].file_path {
                let url = TMDBImageRequest.big(path: image).endPoint
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


// MARK: UICollectionView Delegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailView.castCollectionView {
            viewModel.output.castList.value.count
        } else {
            viewModel.output.posterList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case detailView.castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(viewModel.output.castList.value[indexPath.item])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            cell.configureData(viewModel.output.posterList.value[indexPath.item])
            return cell
        }
        
    }
}

// MARK: ScrollView Delegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        detailView.pageControl.currentPage = Int(pageNumber)
    }
}
