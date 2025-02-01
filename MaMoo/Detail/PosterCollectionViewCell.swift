//
//  PosterCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PosterCollectionViewCell: BaseCollectionViewCell {
    private let imageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .darkGray
        image.clipsToBounds = true
        return image
    }()
    
    override func configureHierarchy() {
        addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureData(_ item: Posters) {
        if let image = item.file_path {
            let newUrl = "https://image.tmdb.org/t/p/w500" + image
            guard let url = URL(string: newUrl) else { return }
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.image = UIImage(systemName: "xmark")
            imageView.contentMode = .center
            imageView.tintColor = .black
        }
    }
}
