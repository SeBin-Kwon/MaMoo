//
//  BaseCollectionViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
