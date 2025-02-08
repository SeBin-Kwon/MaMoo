//
//  ProfileImageViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

class ProfileImageViewModel {
    var inputNum: Observable<Int?> = Observable(nil)
    var inputBackButtonTapped: Observable<Void?> = Observable(())
    var outputContents: ((Int?) -> Void)?
    var outputNum: Observable<Int?> = Observable(nil)
    let profileList = Array(0...11)
    
    init() {
        inputNum.lazyBind { [weak self] num in
            self?.outputNum.value = num
        }
        inputBackButtonTapped.lazyBind { [weak self] value in
            self?.outputContents?(self?.outputNum.value)
        }
    }
    
    
}
