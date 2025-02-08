//
//  MBTICollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import UIKit
import SnapKit

class MBTICollectionViewCell: BaseCollectionViewCell {
    private let mbtiLabel = {
       let label = UILabel()
        label.textColor = .maMooGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let cellBackground = {
       let view = UIView()
        view.layer.borderColor = UIColor.maMooGray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(cellBackground)
        addSubview(mbtiLabel)
    }
    
    override func configureLayout() {
        cellBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mbtiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureData(_ text: String) {
        mbtiLabel.text = text
    }
    
    func updateSelectedCell(_ isSelected: Bool) {
        cellBackground.backgroundColor = isSelected ? .maMooPoint : .clear
        cellBackground.layer.borderWidth = isSelected ? 0 : 1
        mbtiLabel.textColor = isSelected ? UIColor.white : UIColor.maMooGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellBackground.layer.cornerRadius = cellBackground.layer.frame.height / 2
    }
}
