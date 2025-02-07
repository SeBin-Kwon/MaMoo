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
        label.text = "T"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let uiView = {
       let view = UIView()
        view.layer.borderColor = UIColor.maMooLightGray.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(uiView)
        addSubview(mbtiLabel)
    }
    
    override func configureLayout() {
        uiView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mbtiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        uiView.layer.cornerRadius = uiView.layer.frame.height / 2
    }
}
