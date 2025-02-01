//
//  SearchTagCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/31/25.
//

import UIKit

class SearchTagCollectionViewCell: BaseCollectionViewCell {
    let searchLabel = {
        let label = UILabel()
        label.text = "sdf"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let removeButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        config.preferredSymbolConfigurationForImage = imageConfig
        config.image = UIImage(systemName: "xmark")
        config.baseForegroundColor = UIColor.black
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn.configuration = config
//        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
//        btn.tintColor = .black
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(removeButton)
        addSubview(searchLabel)
        
    }
    override func configureLayout() {
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(30)
        }
        removeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    func configureData(_ item: String) {
        searchLabel.text = item
    }
}
