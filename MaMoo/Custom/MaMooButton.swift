//
//  MaMooButton.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/24/25.
//

import UIKit

final class MaMooButton: UIButton {
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .systemFont(ofSize: 16, weight: .bold)
        attributedTitle.foregroundColor = UIColor.maMooPoint
        config.attributedTitle = attributedTitle
        config.cornerStyle = .capsule
        config.background.strokeColor = .maMooPoint
        config.background.strokeWidth = 2
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 14, trailing: 0)
        self.configuration = config
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
