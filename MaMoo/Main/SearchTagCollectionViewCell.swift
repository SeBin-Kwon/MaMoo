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
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    override func configureHierarchy() {
        addSubview(removeButton)
        addSubview(searchLabel)
        
    }
    override func configureLayout() {
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(30)
        }
        removeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureData(_ item: String) {
        searchLabel.text = item
    }
}
