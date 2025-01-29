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
    
    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.backdropScrollView.delegate = self
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightItemTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let movie else { return }
        navigationItem.title = movie.title
        callRequest()
        detailView.pageControl.numberOfPages = backdropsList.count
        configureBackdropScrollView()
    }
    
    private func callRequest() {
        guard let movie else { return }
        NetworkManager.shared.fetchResults(api: TMDBRequest.detailImage(id: movie.id), type: MovieImage.self) { value in
            print(value.backdrops.count)
            self.backdropsList = Array(value.backdrops[0..<5])
            print(self.backdropsList)
        } failHandler: {
            print("fail")
        }
    }
    
    private func configureBackdropScrollView() {
        backdropsList.forEach {
            let newUrl = "https://image.tmdb.org/t/p/w500" + $0.file_path
            guard let url = URL(string: newUrl) else { return }
            let imageView = configureImage()
            imageView.kf.setImage(with: url)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            detailView.backdropScrollView.addSubview(imageView)
        }
    }
    
    private func configureImage() -> UIImageView {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .gray
        return image
    }
    
    @objc func rightItemTapped() {
        print(#function)
    }

}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        detailView.pageControl.currentPage = Int(pageNumber)
    }
}
