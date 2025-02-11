//
//  ProfileImageViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

class ProfileImageViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var num: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        var num: Observable<Int?> = Observable(nil)
    }
    
    let profileList = Array(0...11)
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.num.lazyBind { [weak self] num in
            self?.output.num.value = num
        }
    }
    
    deinit {
        print("ProfileImageViewModel Deinit")
    }
    
}
