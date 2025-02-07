//
//  UIImageView+Extension.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import UIKit

extension UIImageView {
    func addProfileImage(_ num: Int) {
        let image = UIImage(named: "profile_\(num)")
        self.image = image
    }
}
