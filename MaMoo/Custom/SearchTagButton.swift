//
//  SearchTagButton.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit

final class SearchTagButton: BaseButton {
    let backgroundView = {
        let view = UIView()
        view.backgroundColor = .maMooLightGray
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let searchLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let removeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        backgroundView.addSubview(searchLabel)
        addSubview(backgroundView)
        addSubview(removeButton)
    }
    private func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        searchLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundView)
            make.trailing.equalTo(backgroundView).inset(10)
        }
    }
}
