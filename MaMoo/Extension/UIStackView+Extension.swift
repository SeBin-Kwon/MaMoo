//
//  UIStackView+Extension.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit

extension UIStackView {
    func removeAll() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
