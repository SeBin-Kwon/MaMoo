//
//  ProfileImageViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

class ProfileImageViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var num: Observable<Int?> = Observable(nil)
        var backButtonTapped: Observable<Void?> = Observable(())
    }
    
    struct Output {
        var contents: ((Int?) -> Void)?
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
        input.backButtonTapped.lazyBind { [weak self] value in
            self?.output.contents?(self?.output.num.value)
        }
    }
    
    deinit {
        print("ProfileImageViewModel Deinit")
    }
    
}
